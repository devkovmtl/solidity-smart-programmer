// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// payable keyword add functionality to allow to send ether or receive ether
contract Payable {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function deposit() external payable {}

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}