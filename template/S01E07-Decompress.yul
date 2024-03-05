object "Decompress_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      let calldataLength := sub(calldatasize(), 0x04)

      calldatacopy(0x0, 0x04, calldataLength)

      return(0x0, calldataLength)
    }
  }
}