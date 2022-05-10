// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// anyone can deposit ether to this contract
// only owner can withdraw ether from this contract
// when the owner decide to withdraw ether, we destroy the contract
contract PiggyBank {
    address public owner;

    event Deposit(address indexed _from, uint _amount);
    event Withdraw(uint _amount);

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "caller is not owner");
        _;
    }

    // deposit ether
    receive() external payable {
       emit Deposit(msg.sender, msg.value);
    }

    // withdraw ether
    function withdraw() external onlyOwner {
        // send all the eth to the owner
        // delete the contract
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
}