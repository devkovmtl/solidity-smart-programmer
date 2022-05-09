// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// visibility definie how contract or other contracts have access to state 
// variables or function 

// private - only inside contract
// internal - only inside contract and child contracts
// public - inside and outside contract
// external - only outside contract

contract VisibilityBase{
    uint private x = 0;
    uint internal y = 1;
    uint public z = 2;

    function privateFunc() private pure returns (uint) {}

    function internalFunc() internal pure returns (uint) {}
    
    function publicFunc() public pure returns (uint) {}

    function externalFunc() external pure returns (uint) {}

    function examples() external view {
        // access to state var x+ y + z;
        x + y + z;
        // we can call private, internal, public functions 
        privateFunc();
        internalFunc();
        publicFunc();
    }
}

contract VisibilityChild is VisibilityBase {
    function examples2() external view {
        x + z;
        internalFunc();
        publicFunc();
    }
}