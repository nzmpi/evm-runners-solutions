// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IFibHash.sol";

contract FibHash is IFibHash {
    /// @notice Implementation of the fibonacci hash algorithm
    /// @dev Fibonacci constant a = floor(2^bits / phi), where phi = (1 + sqrt(5))/2 = 1.618033 ... (golden ratio)
    /// @param x The number to hash
    /// @param k The size of the resulting hash table: 2^k
    function fibhash(uint256 x, uint8 k) public pure returns (uint256) {
        return 0;
    }
}
