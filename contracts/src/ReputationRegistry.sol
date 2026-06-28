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
    
    uint256 public constant MAX_REPUTATION = 10000;
    uint256 public constant BASE_REWARD = 100;
    uint256 public constant SLASH_PERCENTAGE = 20; // 20%
    uint256 public constant MIN_SLASH = 200;

    // Maps TokenID to Reputation Score
    mapping(uint256 => uint256) public reputationScores;

    event ReputationUpdated(uint256 indexed tokenId, uint256 newScore, bool isPositive);

    constructor(address _identityContract) {
        owner = msg.sender;
        identityContract = AgentIdentity(_identityContract);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    function getReputation(uint256 tokenId) external view returns (uint256) {
        // Reverts if token doesn't exist
        identityContract.ownerOf(tokenId); 
        return reputationScores[tokenId];
    }

    /**
     * @dev Called by BME/Verifier upon successful CP-SNARK generation.
     * Uses diminishing returns: (MAX_REP - CURRENT_REP) / MAX_REP * BASE_REWARD
     */
    function recordSuccess(uint256 tokenId) external onlyOwner {
        identityContract.ownerOf(tokenId); 
        
        uint256 currentScore = reputationScores[tokenId];
        uint256 reward = (BASE_REWARD * (MAX_REPUTATION - currentScore)) / MAX_REPUTATION;
        
        // Ensure at least 1 point is given unless they are perfectly at MAX
        if (reward == 0 && currentScore < MAX_REPUTATION) {
            reward = 1;
        }

        uint256 newScore = currentScore + reward;
        if (newScore > MAX_REPUTATION) {
            newScore = MAX_REPUTATION;
        }
        
        reputationScores[tokenId] = newScore;
        emit ReputationUpdated(tokenId, newScore, true);
    }

    /**
     * @dev Called by BME/Verifier upon a failed or malicious CP-SNARK verification.
     * Slashes 20% of current reputation or MIN_SLASH, whichever is higher.
     */
    function recordFailure(uint256 tokenId) external onlyOwner {
        identityContract.ownerOf(tokenId); 
        
        uint256 currentScore = reputationScores[tokenId];
        uint256 slashAmount = (currentScore * SLASH_PERCENTAGE) / 100;
        
        if (slashAmount < MIN_SLASH) {
            slashAmount = MIN_SLASH;
        }

        uint256 newScore;
        if (slashAmount >= currentScore) {
            newScore = 0;
        } else {
            newScore = currentScore - slashAmount;
        }

        reputationScores[tokenId] = newScore;
        emit ReputationUpdated(tokenId, newScore, false);
    }
}
