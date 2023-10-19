// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import { console } from "forge-std/console.sol";

enum Operation {
    Call,
    DelegateCall
}

contract MockSafe {
    constructor() {}

    /// @dev Fallback function forwards all transactions and returns all received return data.
    fallback() external payable {
        (address to, bytes memory data, Operation operation, uint256 txGas) = abi.decode(
            msg.data,
            (address, bytes, Operation, uint256)
        );
        console.log("MockSafe: to=%s", to);
        console.logBytes(data);
        // (bool success, ) = to.delegatecall(data);
        // if (!success) revert();
        _execute(to, 0, data, operation, txGas);
    }

    function _execute(
        address to,
        uint256 value,
        bytes memory data,
        Operation operation,
        uint256 txGas
    ) internal returns (bool success) {
        if (operation == Operation.DelegateCall) {
            // solhint-disable-next-line no-inline-assembly
            assembly {
                success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
            }
        } else {
            // solhint-disable-next-line no-inline-assembly
            assembly {
                success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
            }
        }
    }
}
