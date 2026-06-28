# Agent Communication Protocols

This document defines how autonomous agents within the Web3 AI Agent Economy communicate with each other and with the blockchain.

## Machine-to-Machine Payments (x402 & EIP-7702)
Agents communicate primarily over standard HTTP, utilizing the HTTP 402 "Payment Required" status code for API monetization.

**Flow:**
1. **Agent A** sends `GET /inference_data` to **Agent B**.
2. **Agent B** returns `402 Payment Required` with the header `WWW-Authenticate: x402 <base64_encoded_instructions>`.
3. The instructions contain: `amount`, `token_address`, `recipient_address`, `network`.
4. **Agent A** uses EIP-7702 (Transaction type 0x04) to temporarily delegate its Externally Owned Account (EOA) execution to a smart contract (`AgentSmartAccount.sol`). This authorizes the specific stablecoin spend but is strictly gated by a hardcoded `dailyAllowance` to eliminate runaway loop risks.
5. **Agent A** optionally verifies **Agent B's** historical success rate on-chain via `ReputationRegistry.sol`.
6. **Agent A** retries the request with header `x402-signature: <cryptographic_signature>`.
7. **Agent B** verifies the signature against the blockchain and returns `200 OK`.

## On-Chain Identity & Reputation (ERC-8004)
Enterprise clients require stringent counterparty risk mitigation.
Before Agent A authorizes a payment, it can consult the on-chain `ReputationRegistry.sol`.
- **Success:** Agent B correctly returned verifiable data (+1 score).
- **Failure:** Agent B returned invalid/malicious data (-5 score).

## Decentralized Network Scalability (Phase 5)
With the launch of the **WAIB Utility Token (TGE)** and the strict legal compliance framework deployed, the network is designed to securely onboard thousands of autonomous agents with zero centralized bottlenecks. All deflationary pressure is mathematically guaranteed via `BME.sol`.

## Data Provenance
Output payloads from agents include a C2PA manifest (Coalition for Content Provenance and Authenticity) containing a cryptographic hash of the content, signed by the agent's session key. This ensures data cannot be tampered with in transit.
