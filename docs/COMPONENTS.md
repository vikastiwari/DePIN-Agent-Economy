# System Components

## 1. Blockchain Contracts (`/contracts`)
- **Agent Smart Account (`AgentSmartAccount.sol`):** The EIP-7702 intent-centric smart account that securely delegates execution from an EOA, enforcing a strict mathematical `dailyAllowance` to prevent AI hallucination exploits.
- **BME Controller (`BME.sol`):** Manages the Burn-and-Mint Equilibrium. Enforces the deflationary ratio (burn 100, mint 95) and distributes minted rewards to Node Operators.
- **Artemis Verifier (`verifier/src/lib.rs`):** A Rust-based smart contract compiled to WASM and deployed on Arbitrum Stylus. 
  - **Optimization:** Utilizes `#![no_std]` and `wasm-opt -O4` to stay under Arbitrum's 24KB contract size limit.
  - **Math (`math.rs`):** Implements Montgomery Multiplication and compile-time precomputations to bypass WASM division overhead.
- **Agent Identity (`AgentIdentity.sol`):** ERC-721 ledger minting verifiable NFT identities for GCP nodes.
- **Reputation Registry (`ReputationRegistry.sol`):** Attached to the identity, strictly penalizes bad actors (-5) and rewards success (+1).
- **Subscription Manager (`SubscriptionManager.sol`):** Handles $5k (Shared) and $25k (Dedicated) B2B SaaS tiers via stablecoins.
- **Utility Token (`UtilityToken.sol`):** The WAIB ERC-20 token. Minting is strictly governed by `BME.sol`.
- **Mainnet Deployer (`script/DeployMainnet.s.sol`):** Automates the 6-contract deployment sequence.

## 2. Agent Network (`/agent`)
- **Orchestrator (`orchestrator.py`):** The LangGraph state machine that manages the agent's logic loop (reasoning, tool selection, data fetching).
- **x402 Client (`agent_client.py`):** The module responsible for intercepting HTTP 402s and generating cryptographic EIP-712 payment signatures via `eth_account` for EIP-7702 delegation.

## 3. Compute Engine (`/compute`)
- **BlockTrain Inference (`blocktrain.py`):** The localized AI inference engine utilizing PyTorch/Hugging Face to run models in a decentralized hardware topology (funded via GCP Web3 Startups program). 
  - **Hardware & Models:** Targets 8B parameter models (Llama-3-8B, Mistral-7B) utilizing AWQ and GGUF 4-bit/8-bit quantization on GCP L4 nodes for sub-2.5s proof-generation latency.
- **Artemis Prover (`prover.py`):** The off-chain Rust/Python hybrid module that generates the Zero-Knowledge proofs for the AI computation using homomorphic polynomial commitments.
