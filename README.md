# evm-runners-levels

Foundry repository for evm-runners.

## Implemented levels

1. Average
2. Fibonacci Hash
3. Fibonacci
4. Prime
5. ArraySort
6. GasEater
7. Decompress

## Usage

### Getting started

To install the levels with the evm-runners cli, run

```bash
evmr init
```

To begin solving a level, run `evmr start` and select the level you want to solve. To validate your solution, run `evmr validate <level>`.

**Alternatively**

You can also install the levels manually by cloning this repository and copying the level template you want to solve from `template/` to `src/`. Then run `forge test` to run the tests.

### Submitting a solution

You can submit a solution with `evmr submit <level>`, or alternatively by submitting the solution bytecode on the [evm-runners website](https://evmr.sh/submit).

## Contributing

Feel free to contribute! In case you want to add a new level, keep the following in mind:

1. evm-runners should be a gradual introduction to the EVM, so introduce one concept at a time
2. The level should make sense and be useful in some context
3. Not a CTF: There should be several ways to solve the level. The task is to find the most efficient solution (regarding gas or codesize)

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

1. The identifier, e.g. `S01E01` or `S01E02`
2. Dash
3. The name of the level

e.g. `S01E03-Fibonacci.sol`

### levels.toml

Add your level info to the `levels.toml` file. See the example below.

```toml
[[levels]]
id = "1"
file = "S01E01-Average"
contract = "Average"
type = "unsigned math"
description = """
  Write a function to find the average of two unsigned integers.
  Further reading: https://bit.ly/4842Lrq

  average(1,1) == 1
  average(1,2) == 1
  average(2,1) == 1
  average(0,4) == 2"""
```

- `id` is the ID of the level, e.g. 3 for S01E01
- `file` is the filename of the template file
- `contract` is the name of the contract (i.e. the level name)
- `type` is the type of the level, e.g. loops, math, etc.
- `description` is the description of the level
