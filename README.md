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
3. Not a CTF: There should be several ways to solve the challenge. The task is to find the most efficient solution (regarding gas or codesize)

The PR should include

1. An interface file in `src/interfaces/`
2. A template file for Solidity, Vyper and Huff in `templates/`
3. A test file in `test/`

The test file consists of the base test (which includes the actual tests and accepts a bytecode env variable as input) and the language specific test contracts, which inherit from the base test and override the deploy function. The CLI will always run the base test file, the language specific test contracts only exist to give the user the option to run the tests with `forge test`.

When adding a new level make sure to follow the naming convention below and place the files in the correct directories. `evm-runners start` will later copy the example template file from `template/<level>` to `src/<level>`.

### Naming convention

The test contracts are named in the following way:

1. Base test: `<Level>TestBase`
2. Solidity test: `<Level>TestSol`
3. Vyper test: `<Level>TestVyper`
4. Huff test: `<Level>TestHuff`

e.g. the test contracts for level `Average` are named `AverageTestBase`, `AverageTestSol`, `AverageTestVyper`, `AverageTestHuff`.

The filename of the template src file is composed of

1. The identifier, e.g. S01E01 or S01E02
2. Dash
3. The level name

e.g. `S01E03-Fibonacci.sol`

### levels.toml

Add your level info to the levels.toml file. See the example below.

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

- `id` is the ID of the level, e.g. 3 for S01E03
- `file` is the filename of the template file
- `contract` is the name of the contract (i.e. the level name)
- `type` is the type of the challenge, e.g. loops, math, etc.
- `description` is the description of the challenge
