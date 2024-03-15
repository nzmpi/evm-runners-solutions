// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IArraySort {
    /// @notice Returns the input array sorted in ascending order
    /// @param arr The array to be sorted
    function arraySort(uint256[] memory arr) external returns (uint256[] memory);
}
