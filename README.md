# evm-runners-levels

Challenges for evm-runners.

## Challenges

1. Average
2. Fibonacci Hash
3. Fibonacci

## Contributing

When adding a new level make sure to follow the naming convention below and place the files in the correct directories.

### Directory Structure

<pre>
.
├── .gitignore          # Git ignore rules
├── .gitmodules         # Git submodule information
├── README.md           # Project documentation and instructions
├── foundry.toml        # Foundry configuration
├── levels.toml         # Level config file, used by the CLI
├── remappings.txt      # Remapping rules for VSCode
├── src                 # Source directory
│   └── interfaces      # Interface definitions for every level
├── template            # Test and source template files for each level
│   └── src	            # src template files
└── test                # Location of the base test files
</pre>

- Language-specific test files of each level are saved in `template`.
- Base test file (which only accepts bytecode) and implements the actual tests is saved in `test`.
- The language-specific test files inherit from the Base test and override the `deploy` function.

`evm-runners start` copies the example template file from `template/src/<level>` to `src/<level>` and the corresponding test file from `template/<level-lang>` to `test`.

### Naming convention

The name of the test contract is composed of

1. The level name, e.g. `Average`
2. "Test"
3. The type, e.g. "Base" for the "Base" test, "Sol" for Solidity, "Huff" for Huff, "Vyper" for Vyper.

So for level `Average`, the test files are called `AverageTestBase`, `AverageTestHuff`, `AverageTestSol`, `AverageTestVyper`.

The filename of the template src file is composed of

1. The identifier, e.g. S01E01 or S01E02
2. Dash
3. The level name

e.g. `S01E03-Fibonacci.sol`
