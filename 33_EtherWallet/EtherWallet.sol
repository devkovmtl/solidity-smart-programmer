// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// contract that can receive either and send either 
// anyone who wants to send ether can send ether to this contract
// only owner can take ether from this contract
contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    // receive ether
    receive() external payable {}


    // send ether oout
    function withdraw(uint _amount) external {
        require(msg.sender == owner, "caller is not owner");
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}