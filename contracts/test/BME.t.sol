// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BME.sol";

contract MockERC20BME {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function mint(address to, uint256 amount) public {
        balanceOf[to] += amount;
    }
    
    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "Insufficient allowance");
        
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}

contract BMETest is Test {
    BME public bme;
    MockERC20BME public token;
    address public agent;
    address public nodeOperator;

    function setUp() public {
        agent = address(0xAAA);
        nodeOperator = address(0xBBB);
        
        token = new MockERC20BME();
        bme = new BME(address(token), 95); // 95% mint ratio
        
        token.mint(agent, 1000 ether);
        token.mint(address(bme), 10000 ether); 
    }

    function testProcessInferencePaymentSuccess() public {
        uint256 burnAmount = 100 ether;
        
        vm.startPrank(agent);
        token.approve(address(bme), burnAmount);
        vm.stopPrank();
        
        bool success = bme.processInferencePayment(agent, nodeOperator, burnAmount);
        
        assertTrue(success);
        
        assertEq(token.balanceOf(agent), 900 ether);
        // BME receives 100, sends 95, netting 5. Initial 10000 + 5 = 10005
        assertEq(token.balanceOf(address(bme)), 10005 ether);
        assertEq(token.balanceOf(nodeOperator), 95 ether);
    }
    
    function testDeflationaryMath() public {
        uint256 burnAmount = 1000 ether;
        
        vm.startPrank(agent);
        token.approve(address(bme), burnAmount);
        vm.stopPrank();
        
        bme.processInferencePayment(agent, nodeOperator, burnAmount);
        
        // Ensure that amount burned is strictly greater than amount minted
        uint256 minted = token.balanceOf(nodeOperator);
        assertGt(burnAmount, minted);
        assertEq(minted, 950 ether);
    }
}
