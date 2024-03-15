// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IModInv {
    /// @notice Returns the modular multiplicative inverse of a modulo m.
    /// @dev See function `_modInv` in S01E08-ModInv.t.sol for an example implementation
    /// @param a The number to find the inverse for.
    /// @param m The modulus.
    /// @return The modular multiplicative inverse of a modulo m.
    function modInv(uint256 a, uint256 m) external pure returns (uint256);
}
