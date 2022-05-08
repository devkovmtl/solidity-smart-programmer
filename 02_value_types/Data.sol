// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Data types can be classified in two types:
// Data Types - values and references
// value: store a values boolean store true/false
// reference: do not store values, they store addresses
// array -> store the reference to where the actual value is stored
contract Data {
    bool public boolValue = true;
    // unsigned integer >= 0
    uint public uintValue = 125; // uint = uint256 0 to 2^256-1
                                 // uint8 = uint8 0 to 2^8-1
                                 // uint16 = uint16 0 to 2^16-1

    // negative or positive integer
    int public intValue = -125; // int = int256 -2^255 to 2^255-1
                                // int128 -2^127 to 2^127-1

    // get max or min value of int
    int public minInt = type(int).min;
    int public maxInt = type(int).max;

    // address
    address public addressValue = 0x0000000000000000000000000000000000000000;

    // bytes32 when we work with keshack
    bytes32 public bytes32Value = 0x0000000000000000000000000000000000000000000000000000000000000000;
}