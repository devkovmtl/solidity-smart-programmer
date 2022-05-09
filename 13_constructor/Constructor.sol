// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Constructor {
    address public owner;
    uint public x;

    // called once only when the contract is created
    // meanly used to set some initial state variables
    constructor(uint _x) {
        // set owner to the account that deployed the contract.
        owner = msg.sender;
        x = _x;
    }
}