// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IDecompress.sol";

contract Decompress is IDecompress {
    /// @dev See {IDecompress-decompress}.
    function decompress(bytes memory compressed) external pure returns (bytes memory) {
        return compressed;
    }
}