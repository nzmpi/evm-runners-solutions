// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "src/interfaces/IGasEater.sol";

contract GasEater is IGasEater {
    function eatGas() external {
        // Store "Hello, World!" in memory
        string memory hello = "Hello, World!";
    }

    function eatMoreGas() external {
        // Store "Hello, World!" in memory
        string memory hello = "Hello, World!";
    }

    function eatEvenMoreGas() external {
        // Store "Hello, World!" in memory
        string memory hello = "Hello, World!";
    }
}
