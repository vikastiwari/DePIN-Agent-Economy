# Project Roadmap (High-Level)

*Note: For granular strategic planning and grant acquisition milestones, see `docs/DETAILED_ROADMAP.md`.*

## Phase 1: Proof of Concept & Foundation (Completed)
- `[x]` Establish Python environment, mock HTTP 402 server, and LangGraph client.

## Phase 2: Arbitrum Stylus & Grants Integration (Completed)
- `[x]` Deploy Smart Account Delegation (EIP-7702) via Foundry.
- `[x]` Build reproducible Docker environments for the Rust Artemis Verifier.
- `[x]` Apply for Arbitrum Foundation Stylus Sprint Grant ($20k-$150k).
- `[x]` Apply for Google Cloud Web3 Startup Scale Tier ($200k in credits).

## Phase 3: Tokenomics & zkML Testnet (Completed)
- `[x]` Compile Artemis Rust verifier stub (`#[no_std]`, `wasm-opt -O4`) for Arbitrum Stylus.
- `[x]` Implement the Burn-and-Mint Equilibrium (BME) smart contracts.
- `[x]` Connect GCP GKE inference nodes to the network.

## Phase 4: Enterprise B2B SaaS Launch (Completed)
- `[x]` Implement ERC-8004 Agent Identity Registries (`AgentIdentity.sol`).
- `[x]` Implement mathematical Reputation Registry (`ReputationRegistry.sol`).
- `[x]` Launch Hosted Pro ($5k/mo) and Institutional Dedicated ($25k/mo) tiers via `SubscriptionManager.sol`.

## Phase 5: Mainnet Deployment & TGE (Completed)
- `[x]` Finalize legal compliance (Utility Token definition under Howey/SEBI) via `LEGAL_COMPLIANCE.md`.
- `[x]` Mainnet deployment scripts via `DeployMainnet.s.sol`.
- `[x]` Token Generation Event (TGE) via `UtilityToken.sol`.
