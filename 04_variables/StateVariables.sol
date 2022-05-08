// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// store data on blockchain
// inside contract outside of function
contract StateVariables {
    uint public myUint = 134; // state variable

    function foo() external {
        // local variable
        // only exist inside function while executing
        uint notStateVariable = 456;
    }
}