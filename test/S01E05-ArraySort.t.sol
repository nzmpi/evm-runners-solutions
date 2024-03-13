// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "./lib/YulDeployer.sol";
import "./lib/VyperDeployer.sol";
import "./lib/HuffDeployer.sol";

import "src/interfaces/IArraySort.sol";

contract ArraySortTestBase is Test {
    IArraySort internal arraySort;

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
        arraySort = IArraySort(deploy());
    }

    function test_s01e05_sanity() public {
        uint256[] memory arr = new uint256[](5);
        arr[0] = 9;
        arr[1] = 2;
        arr[2] = 7;
        arr[3] = 0;
        arr[4] = 5;

        assertEq(arraySort.arraySort(arr), _sort(arr));
    }

    function test_s01e05_fuzz(uint256 length) public {
        length = bound(length, 2, 32);

        uint256[] memory arr = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            arr[i] = uint256(keccak256(abi.encodePacked(block.timestamp, i))) % 2 ** 16;
        }

        // copy array to avoid mutating it
        uint256[] memory arr2 = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            arr2[i] = arr[i];
        }

        assertEq(_sort(arr), arraySort.arraySort(arr2));
    }

    function test_s01e05_gas(uint256 length) public {
        vm.pauseGasMetering();

        length = bound(length, 16, 20);

        uint256[] memory arr = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            arr[i] = uint256(keccak256(abi.encodePacked(block.timestamp, i))) % 2 ** 16;
        }

        vm.resumeGasMetering();

        arraySort.arraySort(arr);
    }

    function test_s01e05_size() public {
        console2.log("Contract size:", address(arraySort).code.length);
        assertLt(address(arraySort).code.length, 10000, "!codesize");
    }

    function _sort(uint256[] memory arr) internal pure returns (uint256[] memory) {
        uint256 n = arr.length;
        bool swapped;

        for (uint256 i = 0; i < n - 1; i++) {
            swapped = false;

            for (uint256 j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    (arr[j], arr[j + 1]) = (arr[j + 1], arr[j]); // Swap the elements
                    swapped = true;
                }
            }

            if (!swapped) {
                break; // If no two elements were swapped, the array is already sorted
            }
        }

        return arr;
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                          SOLIDITY                          */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract ArraySortTestSol is ArraySortTestBase {
    function deploy() internal override returns (address addr) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](4);
        // We get the bytecode of the Solidity contract with
        // forge inspect <contract> bytecode
        deployCommand[0] = "forge";
        deployCommand[1] = "inspect";
        deployCommand[2] = "ArraySort";
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

contract ArraySortTestYul is ArraySortTestBase {
    YulDeployer yulDeployer = new YulDeployer();

    function deploy() internal override returns (address addr) {
        return yulDeployer.deployContract("S01E05-ArraySort");
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                           VYPER                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract ArraySortTestVyper is ArraySortTestBase {
    VyperDeployer vyperDeployer = new VyperDeployer();

    function deploy() internal override returns (address addr) {
        return vyperDeployer.deployContract("S01E05-ArraySort");
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                            HUFF                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract ArraySortTestHuff is ArraySortTestBase {
    function deploy() internal override returns (address addr) {
        HuffDeployer huffDeployer = new HuffDeployer();
        return huffDeployer.deployContract("S01E05-ArraySort");
    }
}
