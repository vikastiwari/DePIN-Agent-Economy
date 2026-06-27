# System Components

## 1. Blockchain Contracts (`/contracts`)
- **ERC-8004 Registry (`ERC8004.sol`):** Handles the minting of Agent NFTs, identity tracking, and immutable reputation scoring. Split into Identity, Reputation, and Validation registries.
- **Artemis Verifier (`ArtemisVerifier.rs`):** A Rust-based smart contract compiled to WASM and deployed on Arbitrum Stylus. 
  - **Optimization:** Must use `#![no_std]` and `wasm-opt -O4` to stay under Arbitrum's 24KB contract size limit.
  - **Math:** Implements Montgomery Multiplication and compile-time precomputations to bypass WASM division overhead.

## 2. Agent Network (`/agent`)
- **Orchestrator (`orchestrator.py`):** The LangGraph state machine that manages the agent's logic loop (reasoning, tool selection, data fetching).
- **x402 Client (`x402_client.py`):** The module responsible for intercepting HTTP 402s and generating cryptographic payment signatures via EIP-7702 delegation.

## 3. Compute Engine (`/compute`)
- **BlockTrain Inference (`blocktrain.py`):** The localized AI inference engine utilizing PyTorch/Hugging Face to run models in a decentralized hardware topology (funded via GCP Web3 Startups program).
- **Artemis Prover (`prover.py`):** The off-chain Rust/Python hybrid module that generates the Zero-Knowledge proofs for the AI computation using homomorphic polynomial commitments.

## 4. Tokenomics Engine
- **BME Controller (`BME.sol`):** A smart contract that manages the Burn-and-Mint Equilibrium. Enforces the deflationary ratio (e.g., burn 100, mint 95) and distributes minted rewards based on the Proof of Useful Work cryptographic weights.
