// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";

contract HuffDeployer is Test {
    ///@notice Compiles a Huff contract and returns the address that the contract was deployed to
    ///@notice If deployment fails, an error will be thrown
    ///@param fileName - The file name of the Huff contract. For example, the file name for "Example.huff" is "Example"
    ///@return deployedAddress - The address that the contract was deployed to
    function deployContract(string memory fileName) public returns (address) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](3);
        // The Huff keyword to compile a contract
        deployCommand[0] = "huffc";
        // The path to the Huff contract file starting from the project root directory
        deployCommand[1] = string.concat("src/", fileName, ".huff");
        deployCommand[2] = "--bytecode";

        ///@notice compile the contract and return the bytecode
        bytes memory bytecode = vm.ffi(deployCommand);

        ///@notice deploy the bytecode with the create instruction
        address deployedAddress;
        assembly {
            deployedAddress := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        ///@notice check that the deployment was successful
        require(deployedAddress != address(0), "HuffDeployer could not deploy contract");

        ///@notice return the address that the contract was deployed to
        return deployedAddress;
    }
}
