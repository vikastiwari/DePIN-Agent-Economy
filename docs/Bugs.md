# Known Bugs and Issues

*This document tracks known issues, technical debt, and environment configurations related to the Web3 AI Agent Economy.*

## Resolved Technical Debt
- **[RESOLVED] Mock Implementations:** The `agent_client.py` has been fully upgraded from string-based mock signatures to actual cryptographic signatures utilizing the `eth_account` library. The EIP-7702 logic is completely verifiable.
- **[RESOLVED] Unbounded Agent Execution:** Initially, EIP-7702 delegation had no bounds. We engineered a strict mathematical `dailyAllowance` inside `AgentSmartAccount.sol` to prevent runaway agent loops from draining the EOA.
- **[RESOLVED] Live GCP E2E Infrastructure Transition:** Removed the local `MockGCPCompute` class in favor of the live `google-cloud-compute` SDK.
- **[RESOLVED] GCP L4 GPU Stockouts:** Random `ZONE_RESOURCE_POOL_EXHAUSTED` errors during L4 Spot instance provisioning. Handled by implementing a dynamic Zone Map cascading fallback (`us-central1` -> `us-east4` -> `us-east1`).
- **[RESOLVED] Vertex AI API Key Leakage / External Billing:** The `google.genai` SDK was initially routing via AI Studio API Keys (`GEMINI_API_KEY`). Fixed by passing `vertexai=True` and `project=PROJECT_ID` to strictly route all billing natively through the GCP environment using Application Default Credentials (ADC).
- **[RESOLVED] Vertex AI Model Deprecation & Region Unavailability:** `gemini-1.5-pro` and `gemini-1.5-flash` threw `404 Not Found` in `us-central1`. Executed a standalone API discovery script and discovered that these were deprecated in the 2026 Vertex cluster. Updated the Gemini Waterfall logic to gracefully cascade through available targets (`gemini-3.5-flash`, `gemini-2.5-pro`, `gemini-2.5-flash`).
- **[RESOLVED] GCP Provisioning Image 404s:** Testing the deep learning VM boot disk (`projects/ml-images/...`) threw a `404`. For E2E infrastructure validation testing, we swapped it for a public Ubuntu image (`projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts`) to ensure the test passes reliably. Custom ML boot disks will still be injected at the production stage.
