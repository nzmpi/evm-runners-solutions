// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "./lib/YulDeployer.sol";
import "./lib/VyperDeployer.sol";
import "./lib/HuffDeployer.sol";

import "src/interfaces/IEcAdd.sol";

contract EcAddTestBase is Test {
    IEcAdd internal ecAdd;

    // prime number defining the finite field for secp256k1
    uint256 constant p = 2 ** 256 - 2 ** 32 - 977;

    function deploy() internal virtual returns (address addr) {
        // first: get the bytecode from the environment if it exists
        bytes memory empty = new bytes(0);
        bytes memory bytecode = vm.envOr("BYTECODE", empty);

        if (bytecode.length > 0) {
            assembly {
                addr := create(0, add(bytecode, 0x20), mload(bytecode))
            }
            return addr;
        }
    }

    function setUp() public {
        ecAdd = IEcAdd(deploy());
    }

    function test_s01e08_sanity() public {
        Vm.Wallet memory walletP = vm.createWallet(uint256(keccak256(bytes("1"))));
        uint256 x = walletP.publicKeyX;
        uint256 y = walletP.publicKeyY;

        // P + 0 = P
        uint256[2] memory userResult = ecAdd.ecAdd([x, y], [uint256(0), uint256(0)]);
        assertEq(userResult[0], x);
        assertEq(userResult[1], y);

        // 0 + Q = Q
        userResult = ecAdd.ecAdd([uint256(0), uint256(0)], [x, y]);
        assertEq(userResult[0], x);
        assertEq(userResult[1], y);

        // P + (-P) = 0
        userResult = ecAdd.ecAdd([x, y], [x, p - y]);
        assertEq(userResult[0], 0);
        assertEq(userResult[1], 0);
    }

    function test_s01e08_fuzz(bytes memory x, bytes memory y) public {
        // get public keys (points on the secp256k1 curve)
        Vm.Wallet memory walletP = vm.createWallet(uint256(keccak256(x)));
        Vm.Wallet memory walletQ = vm.createWallet(uint256(keccak256(y)));
        uint256 x_p = walletP.publicKeyX;
        uint256 y_p = walletP.publicKeyY;
        uint256 x_q = walletQ.publicKeyX;
        uint256 y_q = walletQ.publicKeyY;

        // since Ethereum uses secp256k1, we can assume that the public keys are on the curve
        // but we still check it to be sure
        vm.assume(_isOnCurve([x_p, y_p]) && _isOnCurve([x_q, y_q]));

        uint256[2] memory P = [x_p, y_p];
        uint256[2] memory Q = [x_q, y_q];

        uint256[2] memory result = _ecAdd(P, Q);
        uint256[2] memory userResult = ecAdd.ecAdd(P, Q);

        assertEq(result[0], userResult[0]);
        assertEq(result[1], userResult[1]);
    }

    function test_s01e08_gas(bytes memory x, bytes memory y) public {
        vm.pauseGasMetering();

        // get public keys (points on the secp256k1 curve)
        Vm.Wallet memory walletP = vm.createWallet(uint256(keccak256(x)));
        Vm.Wallet memory walletQ = vm.createWallet(uint256(keccak256(y)));
        uint256 x_p = walletP.publicKeyX;
        uint256 y_p = walletP.publicKeyY;
        uint256 x_q = walletQ.publicKeyX;
        uint256 y_q = walletQ.publicKeyY;

        // since Ethereum uses secp256k1, we can assume that the public keys are on the curve
        // but we still check it to be sure
        vm.assume(_isOnCurve([x_p, y_p]) && _isOnCurve([x_q, y_q]));

        uint256[2] memory P = [x_p, y_p];
        uint256[2] memory Q = [x_q, y_q];

        vm.resumeGasMetering();

        ecAdd.ecAdd(P, Q);
    }

    function test_s01e08_size() public {
        console2.log("Contract size:", address(ecAdd).code.length);
    }

    /// @dev Adds two points P and Q on the secp256k1 curve (y^2 = x^3 + 7 mod p)
    /// @param P The point P = (x_p, y_p).
    /// @param Q The point Q = (x_q, y_q).
    /// @return R The resulting point R = P + Q.
    function _ecAdd(uint256[2] memory P, uint256[2] memory Q) public pure returns (uint256[2] memory R) {
        // if P is the point at infinity return Q
        if (P[0] == 0 && P[1] == 0) return Q;
        // if Q is the point at infinity return P
        if (Q[0] == 0 && Q[1] == 0) return P;
        // if P + Q is the point at infinity return (0, 0)
        if (P[0] == Q[0] && P[1] == (p - Q[1])) return [uint256(0), uint256(0)];

        uint256 x_p = P[0];
        uint256 y_p = P[1];
        uint256 x_q = Q[0];
        uint256 y_q = Q[1];
        uint256 m;

        // Check if P and Q are the same, implying point doubling
        if (x_p == x_q && y_p == y_q) {
            // Double point
            m = mulmod(mulmod(3, mulmod(x_p, x_p, p), p), _modInv(mulmod(2, y_p, p), p), p);
        } else {
            // Add points
            uint256 x_diff_inv = _modInv(addmod(x_q, p - x_p, p), p);
            m = mulmod(addmod(y_q, p - y_p, p), x_diff_inv, p);
        }

        uint256 x_r = addmod(addmod(mulmod(m, m, p), p - x_p, p), p - x_q, p);
        uint256 y_r = addmod(mulmod(m, addmod(x_p, p - x_r, p), p), p - y_p, p);

        return [x_r, y_r];
    }

    /// @dev Checks if a point is on the secp256k1 curve (y^2 = x^3 + 7 mod p)
    /// @param P The point P = (x, y).
    /// @return True if the point is on the curve.
    function _isOnCurve(uint256[2] memory P) internal pure returns (bool) {
        // check if P is within the field range
        if (P[0] > p || P[1] > p) return false;

        // Calculate the left-hand side (lhs) of the equation y^2
        uint256 lhs = mulmod(P[1], P[1], p);

        // Calculate the right-hand side (rhs) of the equation x^3 + 7
        uint256 rhs = addmod(mulmod(mulmod(P[0], P[0], p), P[0], p), 7, p);

        // Check if the point satisfies the curve equation
        return lhs == rhs;
    }

    /// @dev Calculates the modular multiplicative inverse of a modulo m.
    /// @dev source: https://github.com/witnet/elliptic-curve-solidity/
    /// @param a The number to find the inverse for.
    /// @param m The modulus.
    /// @return The modular multiplicative inverse of a modulo m.
    function _modInv(uint256 a, uint256 m) internal pure returns (uint256) {
        uint256 t = 0;
        uint256 newT = 1;
        uint256 r = m;
        uint256 newR = a;

        while (newR != 0) {
            uint256 quotient = r / newR;

            // convert negative number to positive by adding m
            (t, newT) = (newT, addmod(t, (m - mulmod(quotient, newT, m)), m));

            (r, newR) = (newR, r - quotient * newR);
        }

        return t;
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                          SOLIDITY                          */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract EcAddTestSol is EcAddTestBase {
    function deploy() internal override returns (address addr) {
        // The string array input variable used by ffi
        string[] memory deployCommand = new string[](4);
        // We get the bytecode of the Solidity contract with
        // forge inspect <contract> bytecode
        deployCommand[0] = "forge";
        deployCommand[1] = "inspect";
        deployCommand[2] = "EcAdd";
        deployCommand[3] = "bytecode";

        // A local variable to hold the output bytecode
        bytes memory compiledByteCode = vm.ffi(deployCommand);

        // A local variable to hold the address of the deployed Solidity contract
        address deployAddr;

        // Inline assembly code to deploy a contract using bytecode
        assembly {
            deployAddr := create(0, add(compiledByteCode, 0x20), mload(compiledByteCode))
        }

        return deployAddr;
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                            YUL                             */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract EcAddTestYul is EcAddTestBase {
    YulDeployer yulDeployer = new YulDeployer();

    function deploy() internal override returns (address addr) {
        return yulDeployer.deployContract("S01E09-EcAdd");
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                           VYPER                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract EcAddTestVyper is EcAddTestBase {
    VyperDeployer vyperDeployer = new VyperDeployer();

    function deploy() internal override returns (address addr) {
        return vyperDeployer.deployContract("S01E09-EcAdd");
    }
}

/*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
/*                            HUFF                            */
/*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

contract EcAddTestHuff is EcAddTestBase {
    function deploy() internal override returns (address addr) {
        HuffDeployer huffDeployer = new HuffDeployer();
        return huffDeployer.deployContract("S01E09-EcAdd");
    }
}
