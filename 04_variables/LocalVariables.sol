// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// local variable used inside function
contract LocalVariables {
    uint public i;
    bool public b;
    address public myAddress;

    function foo() external {
        // local variable
        // after function stop executing variables will be deleted
        uint x = 123;
        bool f = false;
        // ... more code
        x += 456;
        f = true;

        // state variable from contract
        // update the sate variable
        i = 123;
        b = true;
        myAddress = address(1);
    }

}