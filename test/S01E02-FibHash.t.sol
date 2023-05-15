// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/interfaces/IFibHash.sol";

contract FibHashTestBase is Test {
    IFibHash internal fibhash;

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
        fibhash = IFibHash(deploy());
    }

    function test_s01e02_sanity() public {
        assertEq(_fibhash(0, 3), 0);
        assertEq(_fibhash(5, 6), 5);
        assertEq(_fibhash(12345, 10), 644);
        assertEq(_fibhash(1000_000, 10), 1012);
        assertEq(_fibhash(1234567891337, 10), 566);
    }

    function test_s01e02_fuzz(uint64 x, uint64 k) public {
        x = uint64(bound(x, 0, 2**64 - 1));
        k = uint64(bound(k, 0, 64));

        assertEq(_fibhash(x, k), fibhash.fibhash(x, k));
    }

    function test_s01e02_gas(uint64 x, uint64 k) public view {
        x = uint64(bound(x, 0, 2**64 - 1));
        k = uint64(bound(k, 0, 64));
        
        fibhash.fibhash(x, k);
    }

    function test_s01e02_size() public {
        console2.log("Contract size:", address(fibhash).code.length);
    } 

    function _fibhash(uint64 x, uint64 k) internal pure returns (uint64) {
        uint64 a = 11400714819323198485;
        
        uint64 product;
        unchecked {
            product = (x * a);
        }

        return product >> (64 - k);
    }
}

