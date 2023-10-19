// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import { console } from "forge-std/console.sol";
import { MockERC20Pausable } from "contracts/mock/MockERC20Pausable.sol";
import { Enum } from "safe/Safe.sol";
import { MultiSend, Utils } from "./Utils.s.sol";
import "./Constants.s.sol";

// Pause an ERC20Pausable token
contract Example is Utils {
    function run() external {
        bytes memory transactions;
        uint8 isDelegateCall = 0;
        uint256 value = 0;

        /** TODO  complete */
        uint256 chainId = CHAIN_ETHEREUM;
        uint208 placeholder = uint208(uint256(1e9));
        address to = address(0);
        /** END  complete */

        bytes memory data = abi.encodeWithSelector(MockERC20Pausable.pause.selector, placeholder);
        uint256 dataLength = data.length;
        bytes memory internalTx = abi.encodePacked(isDelegateCall, to, value, dataLength, data);
        transactions = abi.encodePacked(transactions, internalTx);

        bytes memory payloadMultiSend = abi.encodeWithSelector(MultiSend.multiSend.selector, transactions);

        // Verify that the calls will succeed
        address multiSend = address(_chainToMultiSend(chainId));
        address safe = address(_chainToSafe(chainId));
        vm.startBroadcast(safe);
        address(multiSend).delegatecall(payloadMultiSend);
        vm.stopBroadcast();
        _serializeJson(chainId, multiSend, 0, payloadMultiSend, Enum.Operation.DelegateCall, data);
    }
}
