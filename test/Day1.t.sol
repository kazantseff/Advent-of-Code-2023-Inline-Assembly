// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2, console} from "forge-std/Test.sol";
import {Day1} from "../src/day1/Day1.sol";

contract CounterTest is Test {
    Day1 public solution;

    function setUp() public {
        solution = new Day1();
    }

    function testData() public {
        bytes32 data = solution.solve();
    }
}
