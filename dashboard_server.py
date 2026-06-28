import json
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from pydantic import BaseModel
import asyncio

app = FastAPI(title="Web3 AI Agent Economy - Dashboard Bridge")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ConnectionManager:
    def __init__(self):
        self.active_connections: list[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: dict):
        for connection in self.active_connections:
            try:
                await connection.send_text(json.dumps(message))
            except Exception:
                pass

manager = ConnectionManager()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            # We don't expect messages from UI, just keeping connection alive
            data = await websocket.receive_text()
    except WebSocketDisconnect:
        manager.disconnect(websocket)

class EventPayload(BaseModel):
    type: str
    data: dict

@app.post("/emit")
async def emit_event(payload: EventPayload):
    """Endpoint for the Python E2E script to push events to the React UI."""
    await manager.broadcast({
        "type": payload.type,
        **payload.data
    })
    return {"status": "broadcasted"}

if __name__ == "__main__":
    uvicorn.run("dashboard_server:app", host="0.0.0.0", port=8000, reload=True)
