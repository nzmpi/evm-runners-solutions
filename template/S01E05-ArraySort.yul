object "ArraySort_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      // should return the sorted input array
      mstore(0x0, 0x0)
      return(0x0, 0x20)
    }
  }
}