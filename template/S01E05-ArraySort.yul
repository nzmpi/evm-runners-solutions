/*
 * This contract returns the incoming, unsorted array.
 * 
 * Check the ABI Specification to learn how calldata is encoded:
 * https://docs.soliditylang.org/en/v0.8.16/abi-spec.html
 *
 * Can you customize it to return the sorted array instead?
 */
object "ArraySort_Yul" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      // Copy the input array to memory
      let calldataLength := sub(calldatasize(), 0x04)
      calldatacopy(0x0, 0x04, calldataLength)

      // Return the array
      return(0x0, calldataLength)
    }
  }
}