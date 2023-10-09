object "Average_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      // adds two numbers and returns the result
      // can you costumize it to return the average of two numbers instead?
      let sum := add(calldataload(4), calldataload(36))
      mstore(0x0, sum)
      return(0x0, 0x20)
    }
  }
}