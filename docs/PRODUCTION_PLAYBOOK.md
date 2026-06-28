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

To scale this to a world-class enterprise level, we rely exclusively on institutional startup grants.

### Google Cloud Web3 Startups Program
- **Goal:** Acquire the $200,000 USD GCP credit grant to fund the compute layer.
- **Action:** Apply via the [Google for Startups Cloud Program](https://cloud.google.com/startup). You will use our `Web3_AI_Business_Pitch.md` and `Enterprise_Agent_Swarm_White_Paper.md` to prove our architecture's merit.
- **Crucial Step (GPU Quotas):** Even with credits, GCP defaults new projects to 0 GPUs to prevent crypto-mining spam. 
  - Navigate to **IAM & Admin -> Quotas** in your GCP Console.
  - Search for `GPUs (all regions)` and `NVIDIA L4 GPUs`.
  - Submit a manual quota increase request. **Do not run CI/CD tests until this is approved.**

### Arbitrum Foundation Grants Program
- **Goal:** Secure funding for smart contract audits (Trail of Bits, OpenZeppelin) and initial liquidity.
- **Action:** Apply via the [Arbitrum Foundation](https://arbitrum.foundation/grants). Highlight our use of Arbitrum Stylus (Rust WASM) and EIP-7702, as these are massive narrative drivers for the Arbitrum ecosystem.

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
3. Verify that the GCP L4 instance actually spins up in your GCP Console, runs the inference, broadcasts to the live Arbitrum testnet block explorer, and cleanly terminates itself.
4. Only once the Shadow Run passes flawlessly should you commit and push to trigger the GitHub Action.
