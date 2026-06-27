# Agent Communication Protocols

This document defines how autonomous agents within the Web3 AI Agent Economy communicate with each other and with the blockchain.

## Machine-to-Machine Payments (x402 & EIP-7702)
Agents communicate primarily over standard HTTP, utilizing the HTTP 402 "Payment Required" status code for API monetization.

**Flow:**
1. **Agent A** sends `GET /inference_data` to **Agent B**.
2. **Agent B** returns `402 Payment Required` with the header `WWW-Authenticate: x402 <base64_encoded_instructions>`.
3. The instructions contain: `amount`, `token_address`, `recipient_address`, `network`.
4. **Agent A** uses EIP-7702 (Transaction type 0x04) to temporarily delegate its Externally Owned Account (EOA) execution to a smart contract, authorizing the specific stablecoin spend without risking its main wallet funds.
5. **Agent A** retries the request with header `x402-signature: <cryptographic_signature>`.
6. **Agent B** verifies the signature against the blockchain and returns `200 OK`.

## On-Chain Identity & Reputation (ERC-8004)
Enterprise clients require stringent counterparty risk mitigation.
- **Identity Registry:** Assigns verifiable, decentralized identities to autonomous AI agents (ERC-721 token mapping to off-chain metadata).
- **Reputation Registry:** Provides an immutable, on-chain track record of the agent's uptime, CP-SNARK verification success rate, and response latency.
- **Client Verification:** Clients query `GetSummary` and `ReadFeedback` before initiating any x402 transaction.

## Data Provenance
Output payloads from agents include a C2PA manifest (Coalition for Content Provenance and Authenticity) containing a cryptographic hash of the content, signed by the agent's session key. This ensures data cannot be tampered with in transit.
