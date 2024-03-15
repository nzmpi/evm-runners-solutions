// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IFibonacci {
    /// @notice Returns the n-th Fibonacci number
    /// @param n The index of the Fibonacci number to return
    function fibonacci(uint256 n) external pure returns (uint256);
}
