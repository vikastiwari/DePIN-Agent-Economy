# Project Roadmap

This roadmap tracks our progress from Proof of Concept (PoC) to Mainnet Launch.

## Phase 1: Proof of Concept & Foundation
- `[x]` **Step 1: Agentic Foundation and x402 Mocking**
  - Establish Python environment.
  - Build mock HTTP 402 server and LangGraph client.
- `[ ]` **Step 2: Smart Account Delegation (EIP-7702)**
  - Setup Foundry and deploy a Smart Contract Wallet.
  - Grant the agent a session key with scoped spending limits.
- `[ ]` **Step 3: Artemis zkML Verification on Stylus**
  - Compile Artemis Rust verifier to WebAssembly.
  - Deploy to Arbitrum testnet and generate a mock proof off-chain.
- `[ ]` **Step 4: Registry Integration (ERC-8004)**
  - Deploy Identity and Reputation registries.
  - Execute full end-to-end cycle (Task -> Pay -> Infer -> Prove -> Settlement).

## Phase 2: Testnet Deployment
- Integrate real AI models (LLaMA/Mistral) into the compute nodes via GCP.
- Replace mock token transfers with real Arbitrum Sepolia USDC.
- Invite external beta testers to spin up compute nodes and agents.

## Phase 3: Mainnet & Token Launch
- Finalize cryptoeconomic auditing (Proof of Useful Work, Token sinks).
- Launch native utility token.
- Secure SEBI/FIU-IND compliance for Indian operational legality.
- Deploy smart contracts to Arbitrum Mainnet.
