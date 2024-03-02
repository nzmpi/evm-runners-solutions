object "GasEater_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      let helloWorld := 0x48656c6c6f20576f726c64210000000000000000000000000000000000000000
      mstore(0x0, helloWorld)
    }
  }
}