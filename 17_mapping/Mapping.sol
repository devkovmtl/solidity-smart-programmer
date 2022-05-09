// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Mapping 
// How to declare a mapping (simple and nested)
// Set, get delete

// like a dictionary in python
// allow for efficient lookup of values
// {"alice":true, "bob":true, "charlie":true}
contract Mapping {
    // key type => value type
    mapping(string => bool) public map;

    mapping(address => uint) public balances;

    mapping(address => mapping(address => bool)) public isFriend;

    function examples() external {
        balances[msg.sender] = 123;
        uint bal = balances[msg.sender];
        // address 1 not set will be 0
        uint bal2 = balances[address(1)]; // return default value 0

        balances[msg.sender] += 456;

        delete balances[msg.sender]; // balances will be 0

        // the calling is friend to this contract
        isFriend[msg.sender][address(this)] = true;
    }


}