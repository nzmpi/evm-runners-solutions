// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IFibHash {
    function fibhash(uint64 x, uint64 k) external pure returns (uint64);
}