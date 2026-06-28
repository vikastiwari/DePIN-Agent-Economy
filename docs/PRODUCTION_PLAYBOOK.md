# Web3 AI Agent Economy: Production & Grants Playbook

This document is the ultimate guide to taking our architecture from a simulated local environment to a live, globally scalable production network without spending personal funds.

## 1. How the Project Works (Start to End)

### The Setup
1. **The Smart Contracts:** Deployed on Arbitrum (Mainnet/Sepolia). These include `UtilityToken.sol` (WAIB), `BME.sol` (inflation controller), and `AgentSmartAccount.sol` (EIP-7702 delegator).
2. **The Compute Nodes (GCP):** Google Cloud GKE clusters running quantized 8B PyTorch models (Llama-3-8B).
3. **The Identity:** Each GCP node holds an `AgentIdentity.sol` NFT to participate in the network.

### The Execution Flow (The Artemis Gauntlet)
1. **User Request:** A user (or another agent) requests an AI inference task.
2. **EIP-7702 Delegation:** The user signs a Type 0x04 transaction, authorizing `AgentSmartAccount.sol` to execute a payment on their behalf.
3. **Inference (Off-Chain):** The GCP node processes the AI request locally.
4. **ZK Proof Generation:** The node generates an Artemis CP-SNARK proof guaranteeing the inference was calculated correctly without tampering.
5. **On-Chain Settlement:** The node broadcasts the proof and the user's Type 0x04 transaction to Arbitrum. 
6. **Tokenomics (BME):** `BME.sol` verifies the proof via Arbitrum Stylus. It deducts stablecoins from the user's daily allowance, updates the node's Reputation (+1), and mathematically mints WAIB utility tokens to the node operator.

---

## 2. Acquiring and Managing Grants (Zero Personal Capital)

To scale this to a world-class enterprise level without burning personal runway, we rely exclusively on institutional startup grants. Here is the exact playbook to acquire them.

### Google Cloud Web3 Startups Program ($200,000 USD Credits)
The Google for Startups Cloud Program has a dedicated "Web3" tier designed specifically for projects building decentralized infrastructure.

**How to get it:**
1. **The Prerequisites:** You need a registered legal entity (LLC, C-Corp, etc.), a professional domain name, and a functioning website or GitHub repository proving you are actively building.
2. **The Application:** Go to [Google for Startups Cloud Program](https://cloud.google.com/startup) and select the Web3 track.
3. **The Narrative (Crucial):** When they ask what you are building, do not just say "AI". You must explicitly upload our `Web3_AI_Business_Pitch.md`. Highlight that you are building a **Decentralized Physical Infrastructure Network (DePIN) for AI** utilizing Google Kubernetes Engine (GKE) for off-chain inference and Arbitrum for on-chain verification. Google wants to fund startups that will heavily utilize their premium compute products (like L4 and H100 GPUs).
4. **Post-Approval (GPU Quotas):** Once approved, your billing account is credited with $200k. However, GCP strictly limits GPU quotas for new projects to prevent crypto-mining spam. 
   - Navigate to **IAM & Admin -> Quotas** in your GCP Console.
   - Filter for `GPUs (all regions)` and `NVIDIA L4 GPUs`.
   - Submit a manual quota increase request. In the justification box, state: *"We are an approved Web3 Startup program member. We require L4 GPUs to run PyTorch inference for our verifiable AI architecture. We are not mining cryptocurrency."*

### Arbitrum Foundation Grants Program
The Arbitrum Foundation issues milestone-based grants (in ARB tokens) to projects that bring high-quality technical innovation or significant user activity to the Arbitrum ecosystem.

**How to get it:**
1. **The Goal:** Secure funding to pay for Tier-1 smart contract audits (e.g., Trail of Bits, OpenZeppelin) and to bootstrap initial liquidity for the WAIB token.
2. **The Application:** Apply via the [Arbitrum Foundation Grants Portal](https://arbitrum.foundation/grants).
3. **The Narrative (Crucial):** The Arbitrum Foundation does not fund generic forks. You must pitch our architecture's unique technical alignment with Arbitrum's roadmap:
   - **Highlight Arbitrum Stylus:** Emphasize that our Zero-Knowledge `verifier` is written in `#![no_std]` Rust and compiled to WASM to run on Arbitrum Stylus. This proves you are utilizing their newest, most advanced technology.
   - **Highlight EIP-7702:** Point out that our `AgentSmartAccount.sol` utilizes the bleeding-edge EIP-7702 delegation model, positioning Arbitrum as the premier chain for Intent-Centric AI Agents.
4. **Milestone Structuring:** Do not ask for all the money upfront. Structure your grant request in tranches:
   - *Milestone 1 (25%):* Testnet deployment of the Stylus Verifier (The Artemis Gauntlet).
   - *Milestone 2 (50%):* Completion of the independent security audit.
   - *Milestone 3 (25%):* Successful Mainnet launch and Enterprise SaaS onboarding.

---

## 3. CI/CD and Live Testnet Execution

Before deploying to Mainnet, we must flawlessly execute the "Artemis Gauntlet" on Arbitrum Sepolia using live cloud resources.

### Environment Segregation (Burner Wallets)
- **Security Rule:** NEVER use your main treasury wallet or deployer key for automated tests.
- **Action:** Generate a completely fresh Ethereum address (the "Burner Wallet"). 
- **Funding:** Use an Arbitrum Sepolia Faucet to send exactly 0.1 Sepolia ETH to this burner wallet.
- **GitHub Secrets:** Store this burner wallet's private key in GitHub as `SEPOLIA_CI_PRIVATE_KEY`. If the key is ever exposed, you only lose testnet tokens.

### The "Shadow Run"
Debugging GitHub Actions YAML files is painfully slow. Before pushing code to GitHub to trigger the automated CI/CD pipeline, perform a **Shadow Run**:
1. Set your `.env` variables locally to point to the live GCP project and the live Arbitrum Sepolia RPC.
2. Run `pytest tests/e2e_integration.py` directly from your WSL terminal.
3. **Vertex API Integration:** Verify that the GCP L4 instance successfully routes the inference payload through the **Vertex API (Agent API)**, securely generating the Artemis CP-SNARK proof.
4. Verify the on-chain settlement broadcasts successfully to the live Arbitrum testnet block explorer, and the GCP node cleanly terminates itself.
5. Only once the Shadow Run passes flawlessly should you commit and push to trigger the GitHub Action.
