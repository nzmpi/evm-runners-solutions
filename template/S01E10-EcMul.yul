object "EcMul_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      // this code loads point P and scalar k on top of the stack and returns [0, 0].
      // can you modify it to implement the ecMul function instead?
      let x_p := calldataload(4)
      let y_p := calldataload(36)
      let k := calldataload(68)

      mstore(0x0, 0x0)
      mstore(0x20, 0x0)

      return(0x0, 0x40)
    }
  }
}