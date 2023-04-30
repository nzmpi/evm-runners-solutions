## Directory structure

Directory Structure:
.
├── .gitignore          # Git ignore rules
├── .gitmodules         # Git submodule information
├── README.md           # Project documentation and instructions
├── foundry.toml        # Foundry configuration
├── levels.toml         # Level config file, used by the CLI
├── remappings.txt      # Remapping rules for VSCode
├── src                 # source directory
│   └── interfaces      # Interface definitions for every level
├── template            # Test and source template files for each level
│   └── src	            # src template files
└── test                # Test files


Language specific test files of each level are saved in `template`. Base test file (which only accepts bytecode) and implements the actual tests is saved in `test`. The language specific test files inherit from the Base test and override the `deploy` function.

`evm-runners start` copies the example template file from `template/src/<level>` to `src/<level>` and the corresponding test file from `template/<level-lang>` to `test`. 

## Naming convention

The name of the test contract is composed of

1. The level name, e.g. "Average"
2. "Test"
3. The type, e.g. "Base" for the "Base" test, "Sol" for Solidity, "Huff" for Huff, "Vyper" for Vyper. 

So for level "Average", the test files are called "AverageTestBase", "AverageTestHuff", "AverageTestSol", "AverageTestVyper". 

The filename of the template src file is composed of

1. The identifier, e.g. S01E01 or S01E02
2. Dash
3. The level name

e.g. "S01E02-Fibonacci.sol"
