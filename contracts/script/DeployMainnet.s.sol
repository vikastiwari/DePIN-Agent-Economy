// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/UtilityToken.sol";
import "../src/BME.sol";
import "../src/AgentIdentity.sol";
import "../src/ReputationRegistry.sol";
import "../src/SubscriptionManager.sol";

contract DeployMainnet is Script {
    function run() external {
        // Retrieve private key from environment or use a default for simulation
        uint256 deployerPrivateKey = vm.envOr("PRIVATE_KEY", uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));
        address deployerAddress = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // 1. TGE: Deploy Utility Token with 100,000,000 Genesis Supply
        uint256 genesisSupply = 100_000_000 * 10**18;
        UtilityToken utilityToken = new UtilityToken(genesisSupply);

        // 2. Deploy BME Controller (95% mint ratio for deflation)
        BME bme = new BME(address(utilityToken), 95);

        // Fund BME treasury with genesis supply to simulate its future programmatic minting reserves
        utilityToken.transfer(address(bme), genesisSupply);

        // 3. Deploy Identity & Reputation Registries (ERC-8004)
        AgentIdentity identity = new AgentIdentity();
        ReputationRegistry reputation = new ReputationRegistry(address(identity));

        // 4. Deploy Subscription Manager for SaaS (Mocking stablecoin address as deployer for now)
        SubscriptionManager subscription = new SubscriptionManager(deployerAddress, deployerAddress);

        vm.stopBroadcast();
    }
}
