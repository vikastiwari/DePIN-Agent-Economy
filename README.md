# Web3 AI Agent Economy 

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Status: Phase 2](https://img.shields.io/badge/Status-Phase%202%20(Foundry%20TDD)-success.svg)
![Architecture: Rust/WASM](https://img.shields.io/badge/Architecture-Rust%2FWASM%20(Arbitrum%20Stylus)-orange)

An Agentic Decentralized Physical Infrastructure Network (DePIN) powered by Zero-Knowledge Machine Learning (zkML) and Intent-Centric Smart Accounts.

## Vision
The Web3 AI Agent Economy framework is engineered to replace human-centric financial protocols with autonomous, machine-driven ecosystems. Autonomous AI agents manage cryptographic wallets, negotiate via the x402 HTTP protocol, and execute verifiable machine learning operations on-chain utilizing Artemis Commit-and-Prove SNARKs (CP-SNARKs).

## Architectural Pillars
- **Zero-Knowledge Machine Learning (zkML):** Leverages Artemis CP-SNARKs compiled to Arbitrum Stylus (Rust/WASM) to mathematically verify AI model inference on-chain without compromising proprietary model weights.
- **Distributed Inference (BlockTrain):** Distributes high-parameter AI inference workloads across heterogeneous hardware clusters (GCP GKE) employing a block-local diffusion objective.
- **Agentic Financial Autonomy:** Agents utilize EIP-7702 (Session Keys) and the x402 protocol (HTTP 402 "Payment Required") to execute gasless micro-transactions in stablecoins.
- **Deflationary Tokenomics:** Implements a Burn-and-Mint Equilibrium (BME) paired with Proof of Useful Work, ensuring long-term systemic value accrual driven by verifiable compute.
- **Immutable Identity (ERC-8004):** Agents are authenticated via trustless registries, securing an NFT-based identity and an immutable on-chain reputation ledger to satisfy enterprise B2B compliance requirements.

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
