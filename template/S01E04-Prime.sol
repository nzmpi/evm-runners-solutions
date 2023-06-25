// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IPrime.sol";

contract Prime is IPrime {
    /// @dev Returns true if number is prime
    /// @param n The number to check
    function isPrime(uint256 n) public pure returns (bool) {
        return false;
    }
}
