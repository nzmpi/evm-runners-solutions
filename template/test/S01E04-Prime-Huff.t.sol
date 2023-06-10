// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "test/S01E04-Prime.t.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

contract ExternalHuffDeployer {
    address public deployAddr;

    function deploy(string memory fileName) external returns (address) {
        deployAddr = HuffDeployer.deploy(fileName);
        return deployAddr;
    }
}

contract PrimeTestHuff is PrimeTestBase {
    function deploy() internal override returns (address addr) {
        ExternalHuffDeployer huff = new ExternalHuffDeployer();
        try huff.deploy("S01E04-Prime") {
            return huff.deployAddr();
        } catch {
            console2.log("HuffDeployer.deploy failed");
        }
    }
}
