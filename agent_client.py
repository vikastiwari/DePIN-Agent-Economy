import requests
import base64
import json
from typing import TypedDict, Optional
from langgraph.graph import StateGraph, END

# Define the Agent State
class AgentState(TypedDict):
    target_url: str
    response_data: Optional[dict]
    needs_payment: bool
    payment_instructions: Optional[dict]
    signature: Optional[str]
    error: Optional[str]

# Node 1: Request Data
def fetch_data(state: AgentState) -> dict:
    print(f"--> [Agent] Fetching data from {state['target_url']}")
    headers = {}
    if state.get("signature"):
        headers["x402-signature"] = state["signature"]
        print(f"--> [Agent] Attaching signature to request...")

    try:
        response = requests.get(state["target_url"], headers=headers)
        
        if response.status_code == 200:
            print("--> [Agent] Data retrieved successfully!")
            return {"response_data": response.json(), "needs_payment": False}
            
        elif response.status_code == 402:
            print("--> [Agent] Received HTTP 402 Payment Required.")
            auth_header = response.headers.get("WWW-Authenticate", "")
            if auth_header.startswith("x402 "):
                encoded_instr = auth_header.split("x402 ")[1]
                instructions = json.loads(base64.b64decode(encoded_instr).decode())
                return {"needs_payment": True, "payment_instructions": instructions}
            else:
                return {"error": "402 received but no valid x402 instructions found."}
        else:
            return {"error": f"Unexpected status code: {response.status_code}"}
            
    except Exception as e:
        return {"error": str(e)}

# Node 2: Authorize Payment
def authorize_payment(state: AgentState) -> dict:
    print("--> [Agent] Processing x402 payment instructions...")
    instr = state.get("payment_instructions", {})
    amount = instr.get("amount")
    recipient = instr.get("recipient")
    
    print(f"--> [Agent] Generating EIP-3009 gasless signature to pay {amount} to {recipient}...")
    # In reality, this would use a Web3 library to sign an EIP-712/EIP-3009 payload with the agent's session key.
    mock_signature = f"mock_signature_for_{amount}_to_{recipient}"
    
    return {"signature": mock_signature}

# Router Logic
def router(state: AgentState) -> str:
    if state.get("error"):
        print(f"--> [Router] Error encountered: {state['error']}. Halting.")
        return END
    if state.get("needs_payment") and not state.get("signature"):
        print("--> [Router] Routing to authorize_payment.")
        return "authorize_payment"
    elif state.get("response_data"):
        print("--> [Router] Routing to END (success).")
        return END
    elif state.get("signature") and state.get("needs_payment"):
        print("--> [Router] Signature generated, retrying fetch_data.")
        return "fetch_data"
    return END

# Build the LangGraph
workflow = StateGraph(AgentState)

workflow.add_node("fetch_data", fetch_data)
workflow.add_node("authorize_payment", authorize_payment)

workflow.set_entry_point("fetch_data")
workflow.add_conditional_edges("fetch_data", router)
workflow.add_edge("authorize_payment", "fetch_data")

app = workflow.compile()

if __name__ == "__main__":
    print("Starting Agentic x402 Client...")
    initial_state = AgentState(
        target_url="http://127.0.0.1:8000/data",
        response_data=None,
        needs_payment=False,
        payment_instructions=None,
        signature=None,
        error=None
    )
    
    result = app.invoke(initial_state)
    print("\n--- Final Agent State ---")
    print(json.dumps(result, indent=2))
