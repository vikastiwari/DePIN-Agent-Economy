# UI/UX Design Guidelines

The Web3 AI Agent Economy is primarily a backend, machine-to-machine infrastructure project. However, the developer and operator touchpoints must be exceptionally designed.

## Dashboard Principles
If a web frontend is built to monitor the agent swarm or compute nodes, it must follow these principles:
- **Framework:** Next.js or Vite (React).
- **Styling:** Vanilla CSS or heavily customized Tailwind CSS (v3).
- **Aesthetic:** Dark Mode by default. "Glassmorphism" elements for data cards, neon accent colors (Arbitrum Blue, Solana Green) to highlight active transactions, and subtle micro-animations for real-time blockchain event streams.
- **Data Density:** High. Operators need to see live TPS (Transactions Per Second), agent wallet balances, active compute node metrics (GPU utilization, temperatures via GCP APIs), and x402 payment streams.

## Agent CLI (Command Line Interface)
For operators spinning up compute nodes or orchestrating agents via SSH into GCP:
- Logs must be highly structured and color-coded.
- Critical events (e.g. `--> [Agent] HTTP 402 Received`, `--> [Prover] CP-SNARK generated in 1.2s`) should be instantly readable.
- The CLI should mimic modern, beautiful terminal tools with progress bars and dynamic spinners during heavy zkML proof generation.
