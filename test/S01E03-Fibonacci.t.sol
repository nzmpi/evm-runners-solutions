// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";

import "src/interfaces/IFibonacci.sol";

contract FibonacciTestBase is Test {
    IFibonacci internal fibonacci;

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
        fibonacci = IFibonacci(deploy());
    }

    function test_s01e03_sanity() public {
        assertEq(fibonacci.fibonacci(0), 0);
        assertEq(fibonacci.fibonacci(1), 1);
        assertEq(fibonacci.fibonacci(5), 5);
        assertEq(fibonacci.fibonacci(20), 6765);
    }

    function test_s01e03_fuzz(uint256 n) public {
        n = bound(n, 0, 20_000);

        assertEq(_fibonacci(n), fibonacci.fibonacci(n));
    }

    function test_s01e03_gas(uint256 n) public view {
        n = bound(n, 10_000, 11_000);

        fibonacci.fibonacci(n);
    }

    function test_s01e03_size() public {
        console2.log("Contract size:", address(fibonacci).code.length);
        assertLt(address(fibonacci).code.length, 1000, "!codesize");
    }

    // simple fibonacci implementation using a for loop
    function _fibonacci(uint256 n) internal pure returns (uint256) {
        if (n == 0) {
            return 0;
        } else if (n == 1) {
            return 1;
        } else {
            uint256 a = 0;
            uint256 b = 1;
            uint256 c;

            for (uint256 i = 2; i <= n; i++) {
                c = addmod(a, b, type(uint256).max);
                a = b;
                b = c;
            }

            return c;
        }
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                          SOLIDITY                          */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract FibonacciTestSol is FibonacciTestBase {
    function deploy() internal override returns (address addr) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](4);
        // We get the bytecode of the Solidity contract with
        // forge inspect <contract> bytecode
        deployCommand[0] = "forge";
        deployCommand[1] = "inspect";
        deployCommand[2] = "Fibonacci";
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

contract FibonacciTestVyper is FibonacciTestBase {
    function deploy() internal override returns (address addr) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](2);
        // The Vyper keyword to compile a contract
        deployCommand[0] = "vyper";
        // The path to the Vyper contract file starting from the project root directory
        deployCommand[1] = "src/S01E03-Fibonacci.vy";

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

contract FibonacciTestHuff is FibonacciTestBase {
    function deploy() internal override returns (address addr) {
        ExternalHuffDeployer huff = new ExternalHuffDeployer();
        try huff.deploy("S01E03-Fibonacci") {
            return huff.deployAddr();
        } catch {
            console2.log("HuffDeployer.deploy failed");
        }
    }
}
