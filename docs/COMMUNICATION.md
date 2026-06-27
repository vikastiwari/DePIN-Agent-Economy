# Agent Communication Protocols

This document defines how autonomous agents within the Web3 AI Agent Economy communicate with each other and with the blockchain.

## Machine-to-Machine Payments (x402 Protocol)
Agents communicate primarily over standard HTTP, heavily utilizing the HTTP 402 "Payment Required" status code.

**Flow:**
1. **Agent A** sends `GET /inference_data` to **Agent B**.
2. **Agent B** returns `402 Payment Required` with the header `WWW-Authenticate: x402 <base64_encoded_instructions>`.
3. The instructions contain: `amount`, `token_address`, `recipient_address`, `network`.
4. **Agent A** uses its session key to sign an EIP-3009 transfer authorization.
5. **Agent A** retries the request: `GET /inference_data` with header `x402-signature: <cryptographic_signature>`.
6. **Agent B** verifies the signature against the blockchain and returns `200 OK`.

## On-Chain Communication
- **Agent Identity:** Agents communicate their verified status by attaching their ERC-8004 Identity NFT contract address in their HTTP payloads.
- **Data Provenance:** Output payloads from agents include a C2PA manifest (Coalition for Content Provenance and Authenticity) containing a cryptographic hash of the content, signed by the agent's session key. This ensures data cannot be tampered with in transit.
