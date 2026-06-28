// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../script/DeployMainnet.s.sol";

contract DeployTest is Test {
    function testDeploymentIntegrity() public {
        DeployMainnet deployScript = new DeployMainnet();
        
        // Execute the script which simulates the mainnet transaction block
        deployScript.run();

        // If the script runs without reverting, the deployment graph is valid.
        assertTrue(true, "Deployment script executed successfully");
    }
}
