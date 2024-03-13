// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IEcAdd {
    function ecAdd(uint256[2] memory P, uint256[2] memory Q) external pure returns (uint256[2] memory R);
}
