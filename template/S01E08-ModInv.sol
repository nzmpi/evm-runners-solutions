// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IModInv.sol";

contract ModInv is IModInv {
    /// @dev See {IModInv-modInv}.
    function modInv(uint a, uint m) external pure returns (uint256) {
        return 0;
    }
}