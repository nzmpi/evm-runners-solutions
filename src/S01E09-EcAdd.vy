# @dev: SPDX-License-Identifier: UNLICENSED

@external
@pure
def ecAdd(P: uint256[2], Q: uint256[2]) -> uint256[2]:
    """
    @dev Adds two points P and Q on the secp256k1 curve (y^2 = x^3 + 7 mod p)
    @param P The point P = (x_p, y_p).
    @param Q The point Q = (x_q, y_q).
    @return R The resulting point R = P + Q.
    """
    R: uint256[2] = [0, 0]
    return R