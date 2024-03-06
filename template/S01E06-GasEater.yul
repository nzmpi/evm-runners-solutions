object "GasEater_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      let helloWorld := 0x48656c6c6f20576f726c64210000000000000000000000000000000000000000

      switch shr(224, calldataload(0)) // get function selector
      case 0x1bf13571 /* eatEvenMoreGas */ {
        mstore(0x0, helloWorld)
      }
      case 0x651f221d /* eatMoreGas */ {
        mstore(0x0, helloWorld)
      }
      case 0x83f157b1 /* eatGas */ {
        mstore(0x0, helloWorld)
      }
    }
  }
}