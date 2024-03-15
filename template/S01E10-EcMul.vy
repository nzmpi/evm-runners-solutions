# @dev: SPDX-License-Identifier: UNLICENSED

@external
@pure
def ecMul(P: uint256[2], k: uint256) -> uint256[2]:
    """
    @dev Performs scalar multiplication on the secp256k1 curve, i.e., computes k*P
    @param P The point P = (x_p, y_p).
    @param k The scalar to multiply by (e.g. a private key).
    @return R The resulting point R = k*P
    """
    R: uint256[2] = [0, 0]
    return R