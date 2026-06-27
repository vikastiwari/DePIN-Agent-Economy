from fastapi import FastAPI, Request, HTTPException, status
from fastapi.responses import JSONResponse
import base64
import json

app = FastAPI(title="Web3 AI Agent Economy - Mock Server")

# Mock address for the server's wallet
SERVER_WALLET_ADDRESS = "0xServerWalletAddress123"
REQUIRED_PAYMENT_AMOUNT = "1.5" # 1.5 USDC
TOKEN_ADDRESS = "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48" # Mock USDC

@app.get("/data")
async def get_data(request: Request):
    """
    Mock endpoint that requires an x402 payment to access AI data.
    """
    signature = request.headers.get("x402-signature")
    
    if not signature:
        # Construct the x402 payment requirement instruction
        payment_instructions = {
            "amount": REQUIRED_PAYMENT_AMOUNT,
            "token": TOKEN_ADDRESS,
            "recipient": SERVER_WALLET_ADDRESS,
            "network": "Arbitrum"
        }
        encoded_instructions = base64.b64encode(json.dumps(payment_instructions).encode()).decode()
        
        # Return HTTP 402 with the x402 headers
        return JSONResponse(
            status_code=402,
            content={"error": "Payment Required", "message": "This endpoint requires x402 payment authorization."},
            headers={
                "WWW-Authenticate": f"x402 {encoded_instructions}"
            }
        )
        
    # In a real scenario, we would verify the EIP-3009 signature cryptographically here.
    # For the mock, we just check if it contains the word 'mock_signature_for'
    if "mock_signature_for" in signature:
        return {"data": "Highly valuable proprietary AI inference data.", "provenance": "Verified via BlockTrain"}
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Invalid x402 signature")
