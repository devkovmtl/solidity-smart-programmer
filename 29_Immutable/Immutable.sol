// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// when contract is deployed state will never changed
contract Immutable {
    // constant but we can define once the contract is deployed
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    uint public x;

    function foo() external {
        require(msg.sender == owner);
        x +=1 ;
    }
}