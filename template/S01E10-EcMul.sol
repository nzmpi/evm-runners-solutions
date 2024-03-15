// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IEcMul.sol";

contract EcMul is IEcMul {
    /// @dev See {IEcMul-ecMul}.
    function ecMul(uint256[2] memory P, uint256 k) external pure returns (uint256[2] memory R) {
        return [uint256(0), uint256(0)];
    }
}
