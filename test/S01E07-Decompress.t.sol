// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "./lib/YulDeployer.sol";
import "./lib/VyperDeployer.sol";
import "./lib/HuffDeployer.sol";

import "src/interfaces/IDecompress.sol";

contract DecompressTestBase is Test {
    IDecompress internal decompress;

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
        decompress = IDecompress(deploy());
    }

    function test_s01e07_sanity() public {
        assertEq(decompress.decompress(""), "");
        assertEq(decompress.decompress(hex"02ff"), hex"ffff");
        assertEq(decompress.decompress(hex"0a00"), hex"00000000000000000000");
        assertEq(decompress.decompress(hex"0601"), hex"010101010101");
        assertEq(decompress.decompress(hex"01aa02bb03cc"), hex"aabbbbcccccc");
        assertEq(decompress.decompress(hex"010101020103010401050106010701080109"), hex"010203040506070809");
    }

    function test_s01e07_fuzz(bytes memory payload) public {
        vm.assume(payload.length == 32);
        bytes memory compressed = _compress(payload);
        assertEq(decompress.decompress(compressed), payload);
    }

    function test_s01e07_gas(bytes memory payload) public {
        vm.assume(payload.length == 32);
        decompress.decompress(_compress(payload));
    }

    function test_s01e07_size() public {
        console2.log("Contract size:", address(decompress).code.length);
    }

    // Compress bytes using RLE
    function _compress(bytes memory data) internal pure returns (bytes memory) {
        if (data.length == 0) return "";

        bytes memory buffer = new bytes(data.length * 2); // Max possible length

        uint256 bufferIndex = 0;
        bytes1 currentCharacter = data[0];
        uint256 count = 1;

        for (uint256 i = 1; i <= data.length; i++) {
            if (i < data.length && data[i] == currentCharacter) {
                count++;
            } else {
                // Append count and character to buffer
                buffer[bufferIndex++] = bytes1(uint8(count)); // Store count directly
                buffer[bufferIndex++] = currentCharacter;

                if (i < data.length) {
                    currentCharacter = data[i];
                    count = 1; // Reset count for the new character
                }
            }
        }

        bytes memory result = new bytes(bufferIndex);
        for (uint256 i = 0; i < bufferIndex; i++) {
            result[i] = buffer[i];
        }

        return result;
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                          SOLIDITY                          */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract DecompressTestSol is DecompressTestBase {
    function deploy() internal override returns (address addr) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](4);
        // We get the bytecode of the Solidity contract with
        // forge inspect <contract> bytecode
        deployCommand[0] = "forge";
        deployCommand[1] = "inspect";
        deployCommand[2] = "Decompress";
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

contract DecompressTestYul is DecompressTestBase {
    YulDeployer yulDeployer = new YulDeployer();

    function deploy() internal override returns (address addr) {
        return yulDeployer.deployContract("S01E07-Decompress");
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                           VYPER                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract DecompressTestVyper is DecompressTestBase {
    VyperDeployer vyperDeployer = new VyperDeployer();

    function deploy() internal override returns (address addr) {
        return vyperDeployer.deployContract("S01E07-Decompress");
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                            HUFF                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract DecompressTestHuff is DecompressTestBase {
    function deploy() internal override returns (address addr) {
        HuffDeployer huffDeployer = new HuffDeployer();
        return huffDeployer.deployContract("S01E07-Decompress");
    }
}
