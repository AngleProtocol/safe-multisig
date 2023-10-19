// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import { ERC20, ERC20Pausable, Pausable } from "oz/token/ERC20/extensions/ERC20Pausable.sol";

contract MockERC20Pausable is ERC20Pausable {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) Pausable() {}

    function pause(uint256 uselessUint256) external {
        uselessUint256;
        _pause();
    }
}
