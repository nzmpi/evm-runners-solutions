// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "test/S01E01-Average.t.sol";

import "src/S01E01-Average.sol";

contract AverageTestSol is AverageTestBase {
    function deploy() internal override returns (address addr) {
        return address(new Average());
    }
}
