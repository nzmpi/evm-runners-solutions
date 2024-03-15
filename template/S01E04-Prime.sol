// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IPrime.sol";

contract Prime is IPrime {
    /// @dev See {IPrime-isPrime}.
    function isPrime(uint256 n) public pure returns (bool) {
        return false;
    }
}
