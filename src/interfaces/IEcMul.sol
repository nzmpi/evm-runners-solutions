// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IEcMul {
    /// @dev Performs scalar multiplication on the secp256k1 curve, i.e., computes k*P
    /// @param P The point P = (x_p, y_p).
    /// @param k The scalar to multiply by (e.g. a private key).
    /// @return R The resulting point R = k*P
    function ecMul(uint256[2] memory P, uint256 k) external pure returns (uint256[2] memory R);
}
