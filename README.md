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
## Quick Start (Engineering Verification)

### 1. Smart Contract Test-Driven Development (TDD)
We utilize [Foundry](https://book.getfoundry.sh/) for all EVM logic, including EIP-7702, BME Tokenomics, and ERC-8004 Registries.
```bash
cd contracts
forge install
forge test -vvv
```

### 2. Arbitrum Stylus Verifier Compilation
The Artemis CP-SNARK verifier is written in `#![no_std]` Rust. You must use the `cargo-stylus` CLI to compile it to WASM within the 24KB limit.
```bash
cd verifier
cargo stylus check
```

### 3. Agent Protocol Networking
To test the off-chain Python x402 flow and cryptographic signatures:
```bash
source venv/bin/activate
pytest tests/
```
