// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";

import "src/interfaces/IPrime.sol";

contract PrimeTestBase is Test {
    IPrime internal prime;

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
        prime = IPrime(deploy());
    }

    function test_s01e04_sanity() public {
        assertEq(prime.isPrime(0), false);
        assertEq(prime.isPrime(1), false);
        assertEq(prime.isPrime(4), false);
        assertEq(prime.isPrime(7), true);
        assertEq(prime.isPrime(281), true);
        assertEq(prime.isPrime(48991), true);
    }

    function test_s01e04_fuzz(uint256 n) public {
        vm.assume(n < 100_000);
        assertEq(_isPrime(n), prime.isPrime(n));
    }

    function test_s01e04_gas(uint256 n) public view {
        vm.assume(n < 100_000);
        prime.isPrime(n);
    }

    function test_s01e04_size() public {
        console2.log("Contract size:", address(prime).code.length);
        assertLt(address(prime).code.length, 1000, "!codesize");
    }

    // checks if a number is prime
    function _isPrime(uint256 number) public pure returns (bool) {
        if (number < 2) {
            return false;
        }

        for (uint256 i = 2; i * i <= number; i++) {
            if (number % i == 0) {
                return false;
            }
        }

        return true;
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                          SOLIDITY                          */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract PrimeTestSol is PrimeTestBase {
    function deploy() internal override returns (address addr) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](4);
        // We get the bytecode of the Solidity contract with
        // forge inspect <contract> bytecode
        deployCommand[0] = "forge";
        deployCommand[1] = "inspect";
        deployCommand[2] = "Prime";
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

contract PrimeTestVyper is PrimeTestBase {
    function deploy() internal override returns (address addr) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](2);
        // The Vyper keyword to compile a contract
        deployCommand[0] = "vyper";
        // The path to the Vyper contract file starting from the project root directory
        deployCommand[1] = "src/S01E04-Prime.vy";

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
