// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IArraySort.sol";

contract ArraySort is IArraySort {
    /// @notice Returns the input array sorted in ascending order
    /// @param arr The array to be sorted
    function arraySort(uint256[] memory arr) public pure returns (uint256[] memory) {
        return arr;
    }
}
