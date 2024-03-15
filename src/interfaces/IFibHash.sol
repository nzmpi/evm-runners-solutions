// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IFibHash {
    /// @notice Implementation of the fibonacci hash algorithm
    /// @dev See function `_fibhash` in S01E02-FibHash.t.sol for an example implementation
    /// @param x The number to hash
    /// @param k The size of the resulting hash table: 2^k
    function fibhash(uint256 x, uint8 k) external pure returns (uint256);
}
