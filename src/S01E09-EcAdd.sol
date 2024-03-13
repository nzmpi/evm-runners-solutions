// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IEcAdd.sol";

contract EcAdd is IEcAdd {
    // prime number defining the finite field for secp256k1
    uint256 constant p = 2 ** 256 - 2 ** 32 - 977;

    /// @dev Adds two points P and Q on the secp256k1 curve (y^2 = x^3 + 7 mod p)
    /// @param P The point P = (x_p, y_p).
    /// @param Q The point Q = (x_q, y_q).
    /// @return R The resulting point R = P + Q.
    function ecAdd(uint256[2] memory P, uint256[2] memory Q) public pure returns (uint256[2] memory R) {
        return [uint256(0), uint256(0)];
    }
}
