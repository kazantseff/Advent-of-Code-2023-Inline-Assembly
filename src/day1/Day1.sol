// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console2} from "forge-std/console2.sol";
import {CommonBase} from "forge-std/Base.sol";

contract Day1 is CommonBase {
    function solve() external view returns (bytes32 res) {
        string memory data = vm.readFile("./src/day1/input.txt");
        assembly {
            function readByte(input, index) -> result {
                // Calculates which 32-bytes slot contains  the byte of interest
                // If index is 1, rowIndex will be 1 / 32 = 0 (first slot).
                // If index is 33, rowIndex will be 33 / 32 = 1 (second slot).
                let rowIndex := div(index, 0x20)
                // Calculates the position of that byte in the slot
                // colIndex = mod(7, 32) = 7 (The byte is at position 7 within the slot.)
                let colIndex := mod(index, 0x20)
                let slotIndex := add(input, add(0x20, mul(rowIndex, 0x20)))
                // We get the value at the slotIndex, now we need to extract a specific byte
                let slotValue := mload(slotIndex)

                // Shifting by colIndex number of bytes, that should bring the byte to be the most significant
                let leftShift := mul(colIndex, 8)
                // Shifting by 31 byte, makes the most significant bytes the least significant
                let righShift := mul(0x1f, 8)

                result := shl(leftShift, slotValue)
                result := shr(righShift, result)
            }
            let length := mload(data)

            let firstNum := 0
            let lastNum := 0

            for {
                let i := 0
            } lt(i, length) {
                i := add(i, 0x1)
            } {
                // Read each specific byte of the sequence
                let elem := readByte(data, i)

                // If elem is number
                if and(gt(elem, 0x30), lt(elem, 0x40)) {
                    // Convert it to a number
                    lastNum := sub(elem, 0x30)

                    if iszero(firstNum) {
                        firstNum := mul(lastNum, 0xA)
                    }
                }

                // If it's a new line
                if eq(elem, 0x0a) {
                    // Get the sum, add it to result and clear the variables for a new line
                    let sum := add(firstNum, lastNum)
                    res := add(res, sum)

                    firstNum := 0
                    lastNum := 0
                }
            }

            // Take care of the last line
            if not(iszero(firstNum)) {
                let sum := add(firstNum, lastNum)
                res := add(res, sum)
            }
        }
    }
}
