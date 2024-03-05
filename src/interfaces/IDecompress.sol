// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IDecompress {
    function decompress(bytes memory compressed) external pure returns (bytes memory);
}
