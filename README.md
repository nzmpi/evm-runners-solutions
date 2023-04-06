## Directory structure

Language specific test files of each level are saved in `template`. Base test file (which only accepts bytecode) and implements the actual tests is saved in `test`. The language specific test files inherit from the Base test and override the `deploy` function.

`evmrunners start` copies starter file from `template/src/<level>` to `src/<level>` and the corresponding test file from `template/<level-lang>` to `test`. 