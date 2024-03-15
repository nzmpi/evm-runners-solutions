// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IDecompress {
    /// @notice Returns the decompressed calldata
    /// @param compressed The RLE compressed calldata
    function decompress(bytes memory compressed) external pure returns (bytes memory);
}
