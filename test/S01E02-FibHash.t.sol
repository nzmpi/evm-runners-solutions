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
        assertEq(fibhash.fibhash(0, 3), 0);
        assertEq(fibhash.fibhash(5, 6), 5);
        assertEq(fibhash.fibhash(12345, 10), 644);
        assertEq(fibhash.fibhash(1000_000, 10), 1012);
        assertEq(fibhash.fibhash(1234567891337, 10), 566);
    }

    function test_s01e02_fuzz(uint256 x, uint8 k) public {
        vm.assume(k != 0);

        assertEq(_fibhash(x, k), fibhash.fibhash(x, k));
    }

    function test_s01e02_gas(uint256 x, uint8 k) public view {
        vm.assume(k != 0);
        
        fibhash.fibhash(x, k);
    }

    function test_s01e02_size() public {
        console2.log("Contract size:", address(fibhash).code.length);
    } 

    function _fibhash(uint256 x, uint8 k) internal pure returns (uint256) {
        uint256 a = 71563446777022297856526126342750658392501306254664949883333486863006233104021;
        
        uint256 product;
        unchecked {
            product = (x * a);
        }

        return product >> (256 - k);
    }
}

