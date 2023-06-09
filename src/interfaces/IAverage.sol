// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IAverage {
    function average(uint256 a, uint256 b) external pure returns (uint256);
}
