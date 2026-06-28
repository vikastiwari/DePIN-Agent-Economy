// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AgentIdentity.sol";
import "../src/ReputationRegistry.sol";
import "../src/SubscriptionManager.sol";

// Mock stablecoin
contract MockStablecoin {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function mint(address to, uint256 amount) public {
        balanceOf[to] += amount;
    }
    
    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
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

contract Phase4Test is Test {
    AgentIdentity public identity;
    ReputationRegistry public reputation;
    SubscriptionManager public subscriptions;
    MockStablecoin public usdc;

    address public admin = address(this);
    address public nodeOperator = address(0x1111);
    address public enterpriseClient = address(0x2222);
    address public treasury = address(0x3333);

    function setUp() public {
        // Setup Identity & Reputation
        identity = new AgentIdentity();
        reputation = new ReputationRegistry(address(identity));

        // Setup Subscription & Stablecoin
        usdc = new MockStablecoin();
        subscriptions = new SubscriptionManager(address(usdc), treasury);

        // Fund client
        usdc.mint(enterpriseClient, 100_000 * 10**18); // 100k USDC
    }

    // 1. Identity Registry Tests
    function testRegisterAgentIdentity() public {
        uint256 tokenId = identity.registerAgent(nodeOperator, "ipfs://blocktrain-node-data");
        assertEq(identity.ownerOf(tokenId), nodeOperator);
        assertEq(identity.tokenURI(tokenId), "ipfs://blocktrain-node-data");
    }

    // 2. Reputation Registry Tests
    function testReputationMath() public {
        uint256 tokenId = identity.registerAgent(nodeOperator, "ipfs://blocktrain-node-data");
        
        // Starts at 0
        assertEq(reputation.getReputation(tokenId), 0);

        // Record a success (+1)
        reputation.recordSuccess(tokenId);
        assertEq(reputation.getReputation(tokenId), 1);

        // Record a failure (-5)
        reputation.recordFailure(tokenId);
        assertEq(reputation.getReputation(tokenId), -4); // Aggressive penalty applied
    }

    // 3. Subscription Manager Tests
    function testPurchaseDedicatedTier() public {
        vm.startPrank(enterpriseClient);
        
        // Approve 25k USDC
        usdc.approve(address(subscriptions), 25_000 * 10**18);
        
        // Subscribe to DEDICATED
        subscriptions.subscribe(SubscriptionManager.Tier.DEDICATED);
        vm.stopPrank();

        // Treasury receives 25k
        assertEq(usdc.balanceOf(treasury), 25_000 * 10**18);

        // Check subscription status
        (SubscriptionManager.Tier tier, uint256 expiry) = subscriptions.checkSubscription(enterpriseClient);
        assertEq(uint(tier), uint(SubscriptionManager.Tier.DEDICATED));
        assertEq(expiry, block.timestamp + 30 days);
    }
}
