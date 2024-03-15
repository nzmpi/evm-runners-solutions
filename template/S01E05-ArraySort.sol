// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IArraySort.sol";

contract ArraySort is IArraySort {
    /// @dev See {IArraySort-arraySort}.
    function arraySort(uint256[] memory arr) public pure returns (uint256[] memory) {
        return arr;
    }
}
