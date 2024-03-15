// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IEcAdd {
    /// @dev Adds two points P and Q on the secp256k1 curve (y^2 = x^3 + 7 mod p)
    /// @param P The point P = (x_p, y_p).
    /// @param Q The point Q = (x_q, y_q).
    /// @return R The resulting point R = P + Q.
    function ecAdd(uint256[2] memory P, uint256[2] memory Q) external pure returns (uint256[2] memory R);
}
