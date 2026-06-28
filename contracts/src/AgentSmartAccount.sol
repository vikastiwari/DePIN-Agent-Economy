// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract AgentSmartAccount {
    address public owner;

    event PaymentExecuted(address indexed token, address indexed recipient, uint256 amount);

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    /**
     * @dev Executes a payment of ERC20 tokens to a recipient.
     * In an EIP-7702 context, this contract code would reside at the EOA's address,
     * allowing the EOA to natively execute this logic.
     */
    function executePayment(address token, address recipient, uint256 amount) external onlyOwner returns (bool) {
        require(token != address(0), "Invalid token");
        require(recipient != address(0), "Invalid recipient");
        
        bool success = IERC20(token).transfer(recipient, amount);
        require(success, "Transfer failed");
        
        emit PaymentExecuted(token, recipient, amount);
        return true;
    }
}
