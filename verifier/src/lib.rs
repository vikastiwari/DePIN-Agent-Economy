// In a production Stylus deployment, uncomment `#![no_std]` and `extern crate alloc;`
// #![no_std]
// extern crate alloc;

pub mod math;

use alloy_primitives::U256;
use math::{G1Point, G2Point, verify_pairing};

#[cfg(feature = "stylus-sdk")]
use stylus_sdk::prelude::*;

// Define the contract state struct
#[cfg(feature = "stylus-sdk")]
#[stylus_sdk::prelude::sol_storage]
#[stylus_sdk::prelude::entrypoint]
pub struct ArtemisVerifier;

#[cfg(not(feature = "stylus-sdk"))]
pub struct ArtemisVerifier;

/// In a real Stylus contract, we use #[stylus::external] and alloy_primitives.
/// Here we conditionally compile it or provide a native Rust implementation.
#[cfg_attr(feature = "stylus-sdk", stylus_sdk::prelude::external)]
impl ArtemisVerifier {
    /// Verifies a CP-SNARK proof.
    /// ABI matches standard Solidity verifiers: verifyProof(uint256[2], uint256[2][2], uint256[2], uint256[])
    pub fn verify_proof(
        &self,
        a: [U256; 2],
        b: [[U256; 2]; 2],
        c: [U256; 2],
        pub_inputs: Vec<U256>,
    ) -> bool {
        let g1_a = G1Point { x: a[0], y: a[1] };
        let g2_b = G2Point { 
            x: [b[0][0], b[0][1]], 
            y: [b[1][0], b[1][1]] 
        };
        let g1_c = G1Point { x: c[0], y: c[1] };

        // Step 1: Parse proof and inputs
        if pub_inputs.is_empty() {
            return false;
        }

        // Step 2: Use pairing logic to verify zero knowledge proof
        verify_pairing(&g1_a, &g2_b, &g1_c, &pub_inputs)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_verify_valid_proof() {
        let verifier = ArtemisVerifier;
        let a = [U256::from(1), U256::from(2)];
        let b = [
            [U256::from(1), U256::from(2)],
            [U256::from(3), U256::from(4)],
        ];
        let c = [U256::from(5), U256::from(6)];
        let inputs = vec![U256::from(1)];
        
        assert!(verifier.verify_proof(a, b, c, inputs));
    }

    #[test]
    fn test_verify_invalid_proof() {
        let verifier = ArtemisVerifier;
        // Zero points represent an invalid/empty proof
        let a = [U256::from(0), U256::from(0)];
        let b = [
            [U256::from(0), U256::from(0)],
            [U256::from(0), U256::from(0)],
        ];
        let c = [U256::from(0), U256::from(0)];
        let inputs = vec![];
        
        assert!(!verifier.verify_proof(a, b, c, inputs));
    }
}
