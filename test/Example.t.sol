// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import { stdJson } from "forge-std/StdJson.sol";
import { console } from "forge-std/console.sol";
import { MockSafe } from "./mock/MockSafe.sol";
import { Utils } from "./Utils.s.sol";
import "../scripts/foundry/Constants.s.sol";
import { MockERC20Pausable } from "../scripts/foundry/Example.s.sol";

contract ExampleTest is Utils {
    using stdJson for string;

    function setUp() public override {
        super.setUp();
    }

    function testScript() external {
        uint256 chainId = json.readUint("$.chainId");
        (uint256 fork, address gnosisSafe) = _chainToForkAndSafe(chainId);
        vm.selectFork(fork);

        address to = json.readAddress("$.to");
        // uint256 value = json.readUint("$.value");
        uint256 operation = json.readUint("$.operation");
        bytes memory payload = json.readBytes("$.data");

        // Check that the call will succeed
        MockSafe mockSafe = new MockSafe();
        vm.etch(gnosisSafe, address(mockSafe).code);
        vm.prank(gnosisSafe);
        (bool success, ) = gnosisSafe.call(abi.encode(address(to), payload, operation, 1e6));
        if (!success) revert();

        assertEq(MockERC20Pausable(address(0)).paused(), true);
    }
}
