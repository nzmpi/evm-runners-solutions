// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "test/S01E04-Prime.t.sol";

import "src/S01E04-Prime.sol";

contract PrimeTestSol is PrimeTestBase {
    function deploy() internal override returns (address addr) {
        return address(new Prime());
    }
}
