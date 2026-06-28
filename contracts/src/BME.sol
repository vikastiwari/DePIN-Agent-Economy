// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AgentSmartAccount.sol"; // Using IERC20 from here for simplicity

contract BME {
    address public owner;
    IERC20 public utilityToken;
    
    uint256 public mintRatio; // e.g., 95 means 95% is minted for every 100 burned.

    event TokensBurned(address indexed agent, uint256 amount);
    event TokensMinted(address indexed nodeOperator, uint256 amount);
    event RatioUpdated(uint256 newRatio);

    constructor(address _token, uint256 _mintRatio) {
        owner = msg.sender;
        utilityToken = IERC20(_token);
        require(_mintRatio <= 100, "Mint ratio cannot exceed 100%");
        mintRatio = _mintRatio;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    function setMintRatio(uint256 _newRatio) external onlyOwner {
        require(_newRatio <= 100, "Mint ratio cannot exceed 100%");
        mintRatio = _newRatio;
        emit RatioUpdated(_newRatio);
    }

    /**
     * @dev Process a Burn-and-Mint cycle.
     * Agent burns tokens to pay for inference. The protocol mints a percentage
     * back to the node operator who proved the CP-SNARK.
     * Note: In a real environment, this requires minting/burning access on the token contract.
     * For demonstration, we just transfer tokens into this contract (burn) and transfer out (mint).
     */
    function processInferencePayment(address agent, address nodeOperator, uint256 amount) external returns (bool) {
        // "Burn": Transfer tokens from agent to this contract (locking them/burning them)
        require(utilityToken.transferFrom(agent, address(this), amount), "Burn transfer failed");
        emit TokensBurned(agent, amount);

        // Calculate mint amount based on deflationary ratio
        uint256 mintAmount = (amount * mintRatio) / 100;

        // "Mint": Transfer tokens from this contract's reserves to the node operator
        // Assuming this contract holds a treasury to simulate minting.
        require(utilityToken.transfer(nodeOperator, mintAmount), "Mint transfer failed");
        emit TokensMinted(nodeOperator, mintAmount);

        return true;
    }
}
