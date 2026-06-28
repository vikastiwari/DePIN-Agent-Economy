import pytest
import requests
from unittest.mock import patch, MagicMock
from agent_client import workflow, AgentState
import json
import base64
from eth_account import Account

# Create a local test account
Account.enable_unaudited_hdwallet_features()
TEST_ACCT, _ = Account.create_with_mnemonic()
TEST_PRIVATE_KEY = TEST_ACCT.key.hex()

def test_authorize_payment_node():
    """Test that authorize_payment node generates a valid EIP-712 structured signature."""
    from agent_client import authorize_payment
    
    # Mock state
    state = AgentState(
        target_url="http://mocked/data",
        response_data=None,
        needs_payment=True,
        payment_instructions={
            "amount": "1.5",
            "token": "0xMockTokenAddress",
            "recipient": "0xMockRecipientAddress",
            "network": "Arbitrum"
        },
        signature=None,
        error=None,
        private_key=TEST_PRIVATE_KEY
    )
    
    result = authorize_payment(state)
    
    assert "signature" in result
    assert result["signature"].startswith("0x")
    # A valid Ethereum hex signature is 132 characters (0x + 130 hex chars)
    assert len(result["signature"]) == 132

@patch("agent_client.requests.get")
def test_full_agent_flow(mock_get):
    """Test the full LangGraph flow from HTTP 402 to successful retrieval."""
    
    # 1st call returns 402 Payment Required
    mock_response_402 = MagicMock()
    mock_response_402.status_code = 402
    
    payment_instructions = {
        "amount": "1.5",
        "token": "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
        "recipient": "0xServerWalletAddress123",
        "network": "Arbitrum"
    }
    encoded_instructions = base64.b64encode(json.dumps(payment_instructions).encode()).decode()
    mock_response_402.headers = {"WWW-Authenticate": f"x402 {encoded_instructions}"}
    
    # 2nd call returns 200 OK
    mock_response_200 = MagicMock()
    mock_response_200.status_code = 200
    mock_response_200.json.return_value = {"data": "Valuable Data", "provenance": "Verified"}
    
    mock_get.side_effect = [mock_response_402, mock_response_200]
    
    from agent_client import app
    
    initial_state = AgentState(
        target_url="http://mocked/data",
        response_data=None,
        needs_payment=False,
        payment_instructions=None,
        signature=None,
        error=None,
        private_key=TEST_PRIVATE_KEY
    )
    
    final_state = app.invoke(initial_state)
    
    # Assertions
    assert final_state["needs_payment"] is False
    assert final_state["signature"] is not None
    assert final_state["signature"].startswith("0x")
    assert final_state["response_data"]["data"] == "Valuable Data"
    
    # Verify requests.get was called twice (once initially, once with signature)
    assert mock_get.call_count == 2
    
    # Verify second call included the x402-signature header
    second_call_kwargs = mock_get.call_args_list[1][1]
    assert "headers" in second_call_kwargs
    assert "x402-signature" in second_call_kwargs["headers"]
    assert second_call_kwargs["headers"]["x402-signature"] == final_state["signature"]
