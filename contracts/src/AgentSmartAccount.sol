// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract AgentSmartAccount {
    address public owner;
    uint256 public dailyAllowance;
    mapping(uint256 => uint256) public dailySpent;

    event PaymentExecuted(address indexed token, address indexed recipient, uint256 amount);

    constructor(address _owner, uint256 _dailyAllowance) {
        owner = _owner;
        dailyAllowance = _dailyAllowance;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    /**
     * @dev Executes a payment of ERC20 tokens to a recipient.
     * Enforces a strict daily allowance to protect the delegating EOA.
     */
    function executePayment(address token, address recipient, uint256 amount) external onlyOwner returns (bool) {
        require(token != address(0), "Invalid token");
        require(recipient != address(0), "Invalid recipient");
        
        uint256 currentDay = block.timestamp / 1 days;
        require(dailySpent[currentDay] + amount <= dailyAllowance, "Exceeds daily allowance");
        
        dailySpent[currentDay] += amount;
        
        bool success = IERC20(token).transfer(recipient, amount);
        require(success, "Transfer failed");
        
        emit PaymentExecuted(token, recipient, amount);
        return true;
    }
}
