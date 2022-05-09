// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// 2 ways to call parent constructor
// Order of initialization

contract S {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract T {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// initialize with parenthesis and then pass the parameter 
contract U is S("s"), T("t") {
}

contract V is S, T {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {} 
}

contract VV is S("s"), T {
    constructor(string memory _name, string memory _text) T(_text) {} 
}

// order of initialization is determined by the order of inheritance

// Order of execution
// 1. S
// 2. T
// 3. V0
contract V0 is S,T {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {}
}

// Order of execution
// 1. S
// 2. T
// 3. V1
contract v1 is S, T {
    constructor(string memory _name, string memory _text) T(_text) S(_name) {}
}