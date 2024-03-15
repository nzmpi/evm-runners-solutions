// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IFibHash.sol";

contract FibHash is IFibHash {
    /// @dev See {IFibHash-fibhash}.
    function fibhash(uint256 x, uint8 k) public pure returns (uint256) {
        return 0;
    }
}
