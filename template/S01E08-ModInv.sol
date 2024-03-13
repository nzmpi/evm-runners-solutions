// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IModInv.sol";

contract ModInv is IModInv {
    /// @dev See function `_modInv` in S01E08-ModInv.t.sol for an example implementation
    /// @param a The number to find the inverse for.
    /// @param m The modulus.
    /// @return The modular multiplicative inverse of a modulo m.
    function modInv(uint a, uint m) external pure returns (uint256) {
        return 0;
    }
}