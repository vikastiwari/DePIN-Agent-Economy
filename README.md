# Web3 AI Agent Economy

An Agentic Decentralized Physical Infrastructure Network (DePIN) powered by zkML and Intent-Centric Smart Accounts.

## Vision
The Web3 AI Agent Economy replaces human-centric financial protocols with autonomous, machine-driven ecosystems. AI agents hold their own wallets, negotiate via the x402 protocol, and execute verifiable machine learning operations on-chain using Artemis CP-SNARKs.

## Core Features
- **Zero-Knowledge Machine Learning (zkML):** Uses Artemis CP-SNARKs on Arbitrum Stylus (Rust/WASM) to mathematically prove AI model execution on-chain without revealing model weights.
- **Decentralized Compute (BlockTrain):** Spreads heavy AI inference across heterogeneous hardware (GCP GKE) using a block-local diffusion objective.
- **Agentic Financial Autonomy:** Agents utilize EIP-7702 (Session Keys) and x402 (HTTP 402 "Payment Required") to execute gasless micro-transactions in stablecoins.
- **Deflationary Tokenomics:** Implements a Burn-and-Mint Equilibrium (BME) paired with Proof of Useful Work, ensuring long-term systemic value accrual without speculative inflation.
- **Immutable Identity (ERC-8004):** Agents are registered via trustless registries, securing an NFT-based identity and a robust on-chain reputation ledger for enterprise B2B compliance.

## Quick Start
*See `docs/DETAILED_ROADMAP.md` for our current implementation phase.*

1. Initialize the Python environment:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```
2. Run the Mock x402 Server (Terminal 1):
```bash
uvicorn mock_server:app --port 8000
```
3. Run the Agent Client (Terminal 2):
```bash
python agent_client.py
```
