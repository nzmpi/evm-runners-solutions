// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";

contract VyperDeployer is Test {
    ///@notice Compiles a Vyper contract and returns the address that the contract was deployed to
    ///@notice If deployment fails, an error will be thrown
    ///@param fileName - The file name of the Vyper contract. For example, the file name for "Example.vy" is "Example"
    ///@return deployedAddress - The address that the contract was deployed to
    function deployContract(string memory fileName) public returns (address) {
        ///@notice create a list of strings with the commands necessary to compile Vyper contracts
        string[] memory deployCommand = new string[](2);
        deployCommand[0] = "vyper";
        deployCommand[1] = string.concat("src/", fileName, ".vy");

        ///@notice compile the contract and return the bytecode
        bytes memory bytecode = vm.ffi(deployCommand);

        ///@notice deploy the bytecode with the create instruction
        address deployedAddress;
        assembly {
            deployedAddress := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        ///@notice check that the deployment was successful
        require(deployedAddress != address(0), "VyperDeployer could not deploy contract");

        ///@notice return the address that the contract was deployed to
        return deployedAddress;
    }
}
