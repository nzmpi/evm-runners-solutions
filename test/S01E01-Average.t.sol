// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/interfaces/IAverage.sol";

contract AverageTestBase is Test {
    IAverage internal average;

    function deploy() internal virtual returns (address addr) {
        // first: get the bytecode from the environment if it exists
        bytes memory empty = new bytes(0);
        bytes memory bytecode = vm.envOr("BYTECODE", empty);

        if (bytecode.length > 0) {
            assembly {
                addr := create(0, add(bytecode, 0x20), mload(bytecode))
            }
            return addr;
        }
    }

    function setUp() public {
        average = IAverage(deploy());
    }

    function test_s01e01_sanity() public {
        assertEq(average.average(1, 1), 1);
        assertEq(average.average(1, 2), 1);
        assertEq(average.average(2, 1), 1);
        assertEq(average.average(2, 2), 2);
        assertEq(average.average(0, 4), 2);
    }

    function test_s01e01_fuzz(uint256 a, uint256 b) public {
        assertEq((a / 2) + (b / 2) + (a & b & 1), average.average(a, b));
    }

    function test_s01e01_gas(uint256 a, uint256 b) public view {
        average.average(a, b);
    }

    function test_s01e01_size() public view {
        console2.log("Contract size:", address(average).code.length);
    }
}
