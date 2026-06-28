// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AgentIdentity.sol";

/**
 * @title ReputationRegistry
 * @dev Maintains an immutable track record for AI Agents. 
 * Mathematical scoring: +1 for success, -5 for failure.
 */
contract ReputationRegistry {
    AgentIdentity public identityContract;
    address public owner;
    
    // Maps TokenID to Reputation Score
    mapping(uint256 => int256) public reputationScores;

    event ReputationUpdated(uint256 indexed tokenId, int256 newScore, bool isPositive);

    constructor(address _identityContract) {
        owner = msg.sender;
        identityContract = AgentIdentity(_identityContract);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    function getReputation(uint256 tokenId) external view returns (int256) {
        // Reverts if token doesn't exist
        identityContract.ownerOf(tokenId); 
        return reputationScores[tokenId];
    }

    /**
     * @dev Called by BME/Verifier upon successful CP-SNARK generation.
     */
    function recordSuccess(uint256 tokenId) external onlyOwner {
        identityContract.ownerOf(tokenId); 
        reputationScores[tokenId] += 1;
        emit ReputationUpdated(tokenId, reputationScores[tokenId], true);
    }

    /**
     * @dev Called by BME/Verifier upon a failed or malicious CP-SNARK verification.
     * Punished heavily to enforce SLA.
     */
    function recordFailure(uint256 tokenId) external onlyOwner {
        identityContract.ownerOf(tokenId); 
        reputationScores[tokenId] -= 5;
        emit ReputationUpdated(tokenId, reputationScores[tokenId], false);
    }
}
