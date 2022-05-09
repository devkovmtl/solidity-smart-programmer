// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// State variables
// global variables
// function modifiers
// function 
// error handling

// Very simple app to claim ownership of a contract
contract Ownable {
    address public owner;

    constructor() {
        // initialize the owner to the deploying address
        owner = msg.sender;
    }

    // only the owner 
    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "invalid address");
        owner = _newOwner;
    }

}