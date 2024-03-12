object "ModInv_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      // add two numbers and return the result
      // Can you implement the modinv function instead?
      let sum := add(calldataload(4), calldataload(36))
      mstore(0x0, sum)
      return(0x0, 0x20)
    }
  }
}