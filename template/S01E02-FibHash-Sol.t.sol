// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "test/S01E02-FibHash.t.sol";

import "src/S01E02-FibHash.sol";

contract FibHashTestSol is FibHashTestBase {
    function deploy() internal override returns (address addr) {
        return address(new FibHash());
    }
}
