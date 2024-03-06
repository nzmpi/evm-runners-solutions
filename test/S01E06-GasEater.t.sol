// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "./lib/YulDeployer.sol";
import "./lib/VyperDeployer.sol";
import "./lib/HuffDeployer.sol";

import "src/interfaces/IGasEater.sol";

contract GasEaterTestBase is Test {
    IGasEater internal gasEater;

    function deploy() internal virtual returns (address addr) {
        // first: get the bytecode from the environment if it exists
        bytes memory empty = new bytes(0);
        bytes memory bytecode = vm.envOr("BYTECODE", empty);

        if (bytecode.length > 0) {
            assembly {
                addr := create(0, add(bytecode, 0x20), mload(bytecode))
            }
            return addr;
        }
    }

    function setUp() public {
        gasEater = IGasEater(deploy());
    }

    function test_s01e06_sanity() public {
        // check gas usage
        uint256 gasBefore = gasleft();
        gasEater.eatGas();
        uint256 gasAfter = gasleft();
        console2.log("Gas used for 'eatGas':", gasBefore - gasAfter - 5009);
        assertEq(gasBefore - gasAfter - 5009, 719);

        // check gas usage
        gasBefore = gasleft();
        gasEater.eatMoreGas();
        gasAfter = gasleft();
        console2.log("Gas used for 'eatMoreGas':", gasBefore - gasAfter - 503);
        assertEq(gasBefore - gasAfter - 503, 65537);

        // check gas usage
        gasBefore = gasleft();
        gasEater.eatEvenMoreGas();
        gasAfter = gasleft();
        console2.log("Gas used for 'eatEvenMoreGas':", gasBefore - gasAfter - 500);
        assertEq(gasBefore - gasAfter - 500, 15_485_863);
    }

    /// forge-config: default.fuzz.runs = 1
    function test_s01e06_gas(uint256 val) public {
        gasEater.eatGas();
        gasEater.eatMoreGas();
        gasEater.eatEvenMoreGas();
    }

    function test_s01e06_size() public {
        console2.log("Contract size:", address(gasEater).code.length);
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                          SOLIDITY                          */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract GasEaterTestSol is GasEaterTestBase {
    function deploy() internal override returns (address addr) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](4);
        // We get the bytecode of the Solidity contract with
        // forge inspect <contract> bytecode
        deployCommand[0] = "forge";
        deployCommand[1] = "inspect";
        deployCommand[2] = "GasEater";
        deployCommand[3] = "bytecode";

        // A local variable to hold the output bytecode
        bytes memory compiledByteCode = vm.ffi(deployCommand);

        // A local variable to hold the address of the deployed Solidity contract
        address deployAddr;

        // Inline assembly code to deploy a contract using bytecode
        assembly {
            deployAddr := create(0, add(compiledByteCode, 0x20), mload(compiledByteCode))
        }

        return deployAddr;
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                            YUL                             */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract GasEaterTestYul is GasEaterTestBase {
    YulDeployer yulDeployer = new YulDeployer();

    function deploy() internal override returns (address addr) {
        return yulDeployer.deployContract("S01E06-GasEater");
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                           VYPER                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract GasEaterTestVyper is GasEaterTestBase {
    VyperDeployer vyperDeployer = new VyperDeployer();

    function deploy() internal override returns (address addr) {
        return vyperDeployer.deployContract("S01E06-GasEater");
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                            HUFF                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract GasEaterTestHuff is GasEaterTestBase {
    function deploy() internal override returns (address addr) {
        HuffDeployer huffDeployer = new HuffDeployer();
        return huffDeployer.deployContract("S01E06-GasEater");
    }
}
