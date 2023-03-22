// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IAverage {
    function average(uint256 a, uint256 b) external pure returns (uint256);
}

contract Average is IAverage {
    /// @dev Returns the average of two numbers.
    /// @param a The first number.
    /// @param b The second number.
    function average(uint256 a, uint256 b) public pure override returns (uint256) {
        return 0;
    }
}
