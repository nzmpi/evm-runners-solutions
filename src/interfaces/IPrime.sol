// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IPrime {
    /// @notice Returns true if number is prime
    /// @param n The number to check
    function isPrime(uint256 n) external pure returns (bool);
}
