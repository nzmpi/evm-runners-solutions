// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IFibHash {
    function fibhash(uint256 x, uint8 k) external pure returns (uint256);
}
