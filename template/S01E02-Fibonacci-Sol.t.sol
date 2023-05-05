// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "test/S01E02-Fibonacci.t.sol";

import "src/S01E02-Fibonacci.sol";

contract FibonacciTestSol is FibonacciTestBase {
    function deploy() internal override returns (address addr) {
        return address(new Fibonacci());
    }
}
