// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// 3 ways to throw an error in Solidity
// require, revert, assert
// gas refund, state updates are reverted
// custom error - save gase
contract Error {

    // require to do input validation
    function testRequire(uint _i) public pure {
        require(_i < 10, "i > 10");
        // code
    }

    // revert is better if condition is nested in a lot of if statements
    function testRevert(uint _i) public pure {
        if(_i > 10) {
            revert("i > 10");
        }
        // code
    }

    // assert to check for condition that should always be true
    uint public num = 123;
    function testAssert() public view {
        assert(num == 123);
    }

    // declare a custom error 
    // custom error only work with revert
    error MyError(address caller, uint i);

    function testCustomError(uint _i) public view {
        // the longer the message, the more gas it costs
        // require(_i <= 10, "Very long error message error error");
        if(_i > 10) {
            revert(MyError(msg.sender, _i));
        }
        // code
    }
}