// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IAverage {
    /// @notice Returns the average of two numbers.
    /// @param a The first number.
    /// @param b The second number.
    function average(uint256 a, uint256 b) external pure returns (uint256);
}
