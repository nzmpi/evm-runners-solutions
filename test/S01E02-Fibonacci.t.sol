// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/interfaces/IFibonacci.sol";

contract FibonacciTestBase is Test {
    IFibonacci internal fibonacci;

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
        fibonacci = IFibonacci(deploy());
    }

    function test_s01e02_sanity() public {
        assertEq(fibonacci.fibonacci(0), 0);
        assertEq(fibonacci.fibonacci(1), 1);
        assertEq(fibonacci.fibonacci(5), 5);
        assertEq(fibonacci.fibonacci(20), 6765);  
    }

    function test_s01e01_fuzz(uint256 n) public {
        n = bound(n, 0, 370);
        assertEq(_fibonacci(n), fibonacci.fibonacci(n));
    }

    function test_s01e01_gas(uint256 n) public view {
        n = bound(n, 0, 370);
        fibonacci.fibonacci(n);
    }

    function test_s01e01_size() public view {
        console2.log("Contract size:", address(fibonacci).code.length);
    }

    function _fibonacci(uint256 n) internal pure returns (uint256) {
        if (n == 0) {
            return 0;
        } else if (n == 1) {
            return 1;
        } else {
            uint256 a = 0;
            uint256 b = 1;
            uint256 c;

            for (uint256 i = 2; i <= n; i++) {
                c = a + b;
                a = b;
                b = c;
            }

            return c;
        }
    }
}
