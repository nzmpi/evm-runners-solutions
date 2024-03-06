/*
 * This contract returns the incoming, compressed calldata minus the function
 * signature. See the example below for a demonstration:
 * 
 * - input: [
 *	0x5cd3f3a1 
 *  0000000000000000000000000000000000000000000000000000000000000020 
 *  0000000000000000000000000000000000000000000000000000000000000006
 *  01aa02bb03cc0000000000000000000000000000000000000000000000000000
 *  ]
 * - output: [
 *  0000000000000000000000000000000000000000000000000000000000000020
 *  0000000000000000000000000000000000000000000000000000000000000006
 *  01aa02bb03cc0000000000000000000000000000000000000000000000000000
 *  ]
 * 
 * Check the ABI Specification to learn how calldata is encoded:
 * https://docs.soliditylang.org/en/v0.8.16/abi-spec.html
 *
 * Can you customize it to return the uncompressed calldata instead?
 */
object "Decompress_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      // Copy the calldata minus the function signature to memory
      let calldataLength := sub(calldatasize(), 0x04)
      calldatacopy(0x0, 0x04, calldataLength)

      // Return the calldata
      return(0x0, calldataLength)
    }
  }
}