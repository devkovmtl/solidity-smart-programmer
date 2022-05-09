// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Function modifier - resuse code befoer and / or after function
// Basic, inputs, sandwich
contract FunctionModifier {
    bool public paused;
    uint public count;

    function setPause(bool _paused) external {
        paused = _paused;
    }

    modifier whenNotPaused() {
        require(!paused, "Paused");
        _; // call function 
    }
 
    function increment() external whenNotPaused {
        // require(!paused, "Paused");
        count++;
    }

    function decrement() external whenNotPaused {
        // require(!paused, "Paused");
        count--;
    }

    modifier cap(uint _cap) {
        require(_cap < 100,  "x >= 100");
        _;
    }

    function incBy(uint _x) external whenNotPaused cap(_x){
        // require(_x < 100,  "x >= 100");
        count += _x;
    }

    modifier sandwich() {
        count += 10;
        _;
        //  more code here
        count *2;
    }

    function foo() external sandwich {
        count += 1;
    }
}
