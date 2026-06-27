# Architecture Blueprint

## System Overview
The Web3 AI Agent Economy architecture is highly decoupled, isolating computationally heavy machine learning workloads on off-chain infrastructure (GCP) from identity, verification, and settlement mechanisms hosted on the blockchain (Arbitrum Stylus).

## The Three Pillars

### 1. Off-Chain Inference Engine (GCP & BlockTrain)
- **Framework:** PyTorch, Hugging Face, LangChain, LangGraph.
- **Hardware:** GCP Kubernetes Engine (GKE) running L4/H100 instances.
- **Mechanism:** Implements "Spheroid BlockTrain", splitting models into independently trainable blocks using block-local diffusion objectives, allowing for highly distributed, wide-area network serving of 70B+ parameter models.

### 2. On-Chain Verification & Settlement (Arbitrum Stylus)
- **Framework:** Rust (WASM), Solidity, Foundry.
- **Mechanism:** Uses Artemis Commit-and-Prove SNARKs (CP-SNARKs). The GCP nodes generate a proof of inference and submit it to the Rust-based Arbitrum Stylus contract. This reduces commitment check overhead from 11.5x to 1.2x.

### 3. Agentic Networking & Payments (x402 & EIP-7702)
- **Framework:** HTTP, ERC-4337 Paymasters, EIP-7702.
- **Mechanism:** When Agent A requests data from Agent B, Agent B responds with HTTP 402 and an x402 authorization payload. Agent A uses its EIP-7702 delegated smart account session key to sign a gasless transaction, paying Agent B in USDC instantly via an Arbitrum paymaster.

## High-Level Diagram

```mermaid
graph TD
    subgraph Client Layer
        U[User] -->|Task Request| A[Orchestrator AI Agent]
    end

    subgraph Blockchain Layer: Arbitrum Stylus
        A -->|EIP-7702 Session Key| SA[Smart Account]
        SA -->|x402 Payment Auth| PM[ERC-4337 Paymaster]
        REG[ERC-8004 Registries] -.->|Identity/Reputation| A
        VC[Artemis zkML Verifier - Rust/WASM]
    end

    subgraph Off-Chain AI Compute: GCP Infrastructure
        A -->|HTTP 402 Handshake| G_API[GCP API Gateway]
        G_API -->|Distribute Workload| BT[BlockTrain Node Cluster - GKE]
        BT -->|Generate Output + C2PA Manifest| RES[Inference Results]
        BT -->|Generate CP-SNARK| PRF[Artemis Prover]
    end

    RES -->|Return Payload| A
    PRF -->|Submit Proof| VC
    VC -->|Trigger Payout| PM
    PM -->|Token Transfer| BT
```
