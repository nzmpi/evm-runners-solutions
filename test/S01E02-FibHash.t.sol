// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/interfaces/IFibHash.sol";

contract FibHashTestBase is Test {
    IFibHash internal fibhash;

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
        fibhash = IFibHash(deploy());
    }

    function test_s01e02_sanity() public {
        assertEq(fibhash.fibhash(0, 3), 0);
        assertEq(fibhash.fibhash(5, 6), 5);
        assertEq(fibhash.fibhash(12345, 10), 644);
        assertEq(fibhash.fibhash(1000_000, 10), 1012);
        assertEq(fibhash.fibhash(1234567891337, 10), 566);
    }

    function test_s01e02_fuzz(uint256 x, uint8 k) public {
        vm.assume(k != 0);

        assertEq(_fibhash(x, k), fibhash.fibhash(x, k));
    }

    function test_s01e02_gas(uint256 x, uint8 k) public view {
        vm.assume(k != 0);

        fibhash.fibhash(x, k);
    }

    function test_s01e02_size() public view {
        console2.log("Contract size:", address(fibhash).code.length);
    }

    function _fibhash(uint256 x, uint8 k) internal pure returns (uint256) {
        uint256 a = 71563446777022297856526126342750658392501306254664949883333486863006233104021;

        uint256 product;
        unchecked {
            product = (x * a);
        }

        return product >> (256 - k);
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                          SOLIDITY                          */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract FibHashTestSol is FibHashTestBase {
    function deploy() internal override returns (address addr) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](4);
        // We get the bytecode of the Solidity contract with
        // forge inspect <contract> bytecode
        deployCommand[0] = "forge";
        deployCommand[1] = "inspect";
        deployCommand[2] = "FibHash";
        deployCommand[3] = "bytecode";

        // A local variable to hold the output bytecode
        bytes memory compiledByteCode = vm.ffi(deployCommand);

        // A local variable to hold the address of the deployed Vyper contract
        address deployAddr;

        // Inline assembly code to deploy a contract using bytecode
        assembly {
            deployAddr := create(0, add(compiledByteCode, 0x20), mload(compiledByteCode))
        }

        return deployAddr;
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                           VYPER                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract FibHashTestVyper is FibHashTestBase {
    function deploy() internal override returns (address addr) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](2);
        // The Vyper keyword to compile a contract
        deployCommand[0] = "vyper";
        // The path to the Vyper contract file starting from the project root directory
        deployCommand[1] = "src/S01E02-FibHash.vy";

        // A local variable to hold the output bytecode
        bytes memory compiledByteCode = vm.ffi(deployCommand);

        // A local variable to hold the address of the deployed Vyper contract
        address deployAddr;

        // Inline assembly code to deploy a contract using bytecode
        assembly {
            deployAddr := create(0, add(compiledByteCode, 0x20), mload(compiledByteCode))
        }

        return deployAddr;
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                            HUFF                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

contract ExternalHuffDeployer {
    address public deployAddr;

    function deploy(string memory fileName) external returns (address) {
        deployAddr = HuffDeployer.deploy(fileName);
        return deployAddr;
    }
}

contract FibHashTestHuff is FibHashTestBase {
    function deploy() internal override returns (address addr) {
        ExternalHuffDeployer huff = new ExternalHuffDeployer();
        try huff.deploy("S01E02-Fibonacci") {
            return huff.deployAddr();
        } catch {
            console2.log("HuffDeployer.deploy failed");
        }
    }
}
