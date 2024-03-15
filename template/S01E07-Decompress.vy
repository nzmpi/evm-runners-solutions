# @dev: SPDX-License-Identifier: UNLICENSED

@external
@pure
def decompress(compressed: Bytes[512]) -> Bytes[512]:
    """
    @notice Returns the decompressed calldata 
    @param compressed The RLE compressed calldata
    """
    return compressed