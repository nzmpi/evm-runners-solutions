object "Prime_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      // should return true if the input number is prime
      let num := calldataload(4)
      mstore(0x0, 0x0)
      return(0x0, 0x20)
    }
  }
}