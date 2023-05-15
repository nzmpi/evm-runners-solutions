// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "src/interfaces/IFibHash.sol";

contract FibHash is IFibHash {
    /// @dev Implementation of the fibonacci hash algorithm
    /// @param x The number to hash
    /// @param k The size of the resulting hash table: 2^k
    function fibhash(uint64 x, uint64 k) public pure returns (uint64) {
        return 0;
    }
}
