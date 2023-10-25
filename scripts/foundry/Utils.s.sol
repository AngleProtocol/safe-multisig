// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import { MultiSend } from "safe/libraries/MultiSend.sol";
import { Safe, Enum } from "safe/Safe.sol";
import "./Constants.s.sol";

/// @title Utils
/// @author Angle Labs, Inc.
contract Utils is Script {
    function _serializeJson(
        uint256 chainId,
        address safe,
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation,
        bytes memory additionalData
    ) internal {
        string memory json = "";
        vm.serializeUint(json, "chainId", chainId);
        vm.serializeAddress(json, "safe", safe);
        vm.serializeAddress(json, "to", to);
        vm.serializeUint(json, "value", value);
        vm.serializeUint(json, "operation", uint256(operation));
        vm.serializeBytes(json, "additionalData", additionalData);
        string memory finalJson = vm.serializeBytes(json, "data", data);

        console.log(finalJson);
        vm.writeJson(finalJson, "./scripts/foundry/transaction.json");
    }

    function _chainToMultiSend(uint256 chain) internal pure returns (MultiSend) {
        if (chain == CHAIN_ETHEREUM) return multiSendEthereum;
        else if (chain == CHAIN_POLYGON) return multiSendPolygon;
        else if (chain == CHAIN_ARBITRUM) return multiSendArbitrum;
        else if (chain == CHAIN_OPTIMISM) return multiSendOptimism;
        else if (chain == CHAIN_AVALANCHE) return multiSendAvalanche;
        else revert("chain not supported");
    }

    function _chainToSafe(uint256 chain) internal pure returns (Safe) {
        if (chain == CHAIN_ETHEREUM) return safeEthereum;
        else if (chain == CHAIN_POLYGON) return safePolygon;
        else if (chain == CHAIN_ARBITRUM) return safeArbitrum;
        else if (chain == CHAIN_OPTIMISM) return safeOptimism;
        else if (chain == CHAIN_AVALANCHE) return safeAvalanche;
        else revert("chain not supported");
    }
}
