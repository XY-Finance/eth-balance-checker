// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {BalanceChecker} from "../contracts/BalanceChecker.sol";

contract DeployBalanceChecker is Script {
    // forge script script/DeployBalanceChecker.s.sol:DeployBalanceChecker --rpc-url https://compatible-holy-mansion.arbitrum-sepolia.quiknode.pro/xxx/  --private-key xxx --broadcast
    function run() external returns (BalanceChecker) {
        // Begin recording transactions for deployment
        vm.startBroadcast();

        // Deploy the contract
        BalanceChecker balanceChecker = new BalanceChecker();

        vm.stopBroadcast();
        
        return balanceChecker;
    }
}