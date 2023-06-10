// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/interfaces/IPrime.sol";

contract PrimeTestBase is Test {
    IPrime internal prime;

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
        prime = IPrime(deploy());
    }

    function test_s01e04_sanity() public {
        assertEq(prime.isPrime(0), false);
        assertEq(prime.isPrime(1), false);
        assertEq(prime.isPrime(4), false);
        assertEq(prime.isPrime(7), true);
    }

    function test_s01e04_fuzz(uint256 n) public {
        vm.assume(n < 1000_000);
        assertEq(_isPrime(n), prime.isPrime(n));
    }

    function test_s01e04_gas(uint256 n) public view {
        vm.assume(n < 1000_000);
        prime.isPrime(n);
    }

    function test_s01e04_size() public {
        console2.log("Contract size:", address(prime).code.length);
        assertLt(address(prime).code.length, 10000, "!codesize");
    }

    // checks if a number is prime
    function _isPrime(uint256 number) public pure returns (bool) {
        if (number < 2) {
            return false;
        }

        for (uint256 i = 2; i * i <= number; i++) {
            if (number % i == 0) {
                return false;
            }
        }

        return true;
    }
}
