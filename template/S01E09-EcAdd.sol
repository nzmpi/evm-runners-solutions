// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IEcAdd.sol";

contract EcAdd is IEcAdd {
    // prime number defining the finite field for secp256k1
    uint256 constant p = 2 ** 256 - 2 ** 32 - 977;

    /// @dev See {IEcAdd-ecAdd}.
    function ecAdd(uint256[2] memory P, uint256[2] memory Q) public pure returns (uint256[2] memory R) {
        return [uint256(0), uint256(0)];
    }
}
