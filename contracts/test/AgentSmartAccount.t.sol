// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AgentSmartAccount.sol";
import "forge-std/console.sol";

// Mock ERC20 Token for testing
contract MockERC20 {
    mapping(address => uint256) public balanceOf;
    function mint(address to, uint256 amount) public {
        balanceOf[to] += amount;
    }
    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}

contract AgentSmartAccountTest is Test {
    AgentSmartAccount public account;
    MockERC20 public token;
    address public owner;
    address public recipient;

    function setUp() public {
        owner = address(this);
        recipient = address(0x123);
        account = new AgentSmartAccount(owner);
        token = new MockERC20();
        
        // Fund the smart account with mock tokens
        token.mint(address(account), 1000 ether);
    }

    function testExecutePaymentSuccess() public {
        uint256 amount = 1.5 ether;
        
        // Assert initial state
        assertEq(token.balanceOf(recipient), 0);
        
        // Execute payment
        bool success = account.executePayment(address(token), recipient, amount);
        
        // Assert outcome
        assertTrue(success);
        assertEq(token.balanceOf(recipient), amount);
        assertEq(token.balanceOf(address(account)), 1000 ether - amount);
    }
    
    function testExecutePaymentUnauthorized() public {
        // Change caller to someone other than owner
        vm.prank(address(0x456));
        vm.expectRevert("Unauthorized");
        account.executePayment(address(token), recipient, 1 ether);
    }
}
