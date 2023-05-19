// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IFibHash {
    function fibhash(uint256 x, uint8 k) external pure returns (uint64);
}