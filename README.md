# evm-runners-levels

Challenges for evm-runners.

## Challenges

1. Average
2. Fibonacci Hash
3. Fibonacci

## Contributing

Feel free to contribute! In case you want to add a new level, keep the following in mind:

1. evm-runners should be a gradual introduction to the EVM, so introduce one concept at a time
2. The challenge should make sense and be useful in some context
3. Not a CTF: There should be several ways to solve the challenge. The task is to find the most efficient solution (gas or codesize)

The PR should include

1. An interface file in `src/interfaces/`
2. A template file for Solidity, Vyper and Huff in `templates/src/`
3. A base test file in `test/`
4. Language specific test files in `templates/test/` (Solidity, Vyper, Huff)

The base test file includes the actual tests and accepts a bytecode env variable as input. The language specific test files inherit from the base test and override the deploy function. The CLI will always run the base test file, the language specific test files only exist to give the user the option to run the tests himself with `forge test`.

When adding a new level make sure to follow the naming convention below and place the files in the correct directories. `evm-runners start` will later copy the example template file from `template/src/<level>` to `src/<level>` and the corresponding test file from `template/test/<level>` to `test`.

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

### levels.toml

Add your level to the levels.toml file. This is needed for the CLI to work. See the example below.

```toml
[[levels]]
id = "3"
file = "S01E03-Fibonacci"
contract = "Fibonacci"
type = "loops"
description = """ /**
  * Calculate the n-th Fibonacci number.
  * Note: Use the modulo operator to prevent the result from overflowing.
  *
  * fibonacci(0) == 0
  * fibonacci(1) == 1
  * fibonacci(5) == 5
  * fibonacci(20) == 6765
  */
"""
```
