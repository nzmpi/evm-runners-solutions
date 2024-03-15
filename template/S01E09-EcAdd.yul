object "EcAdd_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      // this code loads points P and Q on top of the stack and returns [0, 0].
      // can you modify it to implement the ecAdd function instead?
      let x_p := calldataload(4)
      let y_p := calldataload(36)
      let x_q := calldataload(68)
      let y_q := calldataload(100)

      mstore(0x0, 0x0)
      mstore(0x20, 0x0)

      return(0x0, 0x40)
    }
  }
}