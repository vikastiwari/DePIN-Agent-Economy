# Known Bugs and Issues

*This document tracks known issues, technical debt, and environment configurations related to the Web3 AI Agent Economy.*

## Phase 1: Agentic Foundation
- **Mock Implementations:** Currently, `agent_client.py` relies on a string-based mock signature (`mock_signature_for_X_to_Y`). In Step 2, this must be replaced with actual cryptographic signatures utilizing the `eth_account` or `web3.py` libraries.
- **Dependencies:** The initial implementation uses basic HTTP clients; migrating to asynchronous Web3 RPC calls will require `httpx` and `web3.py` optimizations.
