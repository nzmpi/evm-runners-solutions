# @dev: SPDX-License-Identifier: UNLICENSED

@external
@pure
def decompress(compressed: Bytes[512]) -> Bytes[512]:
    return compressed