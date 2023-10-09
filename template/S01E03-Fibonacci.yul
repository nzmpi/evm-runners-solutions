object "Fibonacci_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      // returns the input number
      // can you costumize this code to return the n-th Fibonacci number?
      let num := calldataload(4)
      mstore(0x0, num)
      return(0x0, 0x20)
    }
  }
}