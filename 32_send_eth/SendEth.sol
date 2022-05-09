// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// 3 ways to send ETH
// transfer (2300 gas, reverts)
// send - 2300 gas, returns bool
// call - all gas, returns bool and data

// to be able to send ether to contract the contract must be able to receive
contract SendEther {

    constructor() payable {}

    receive() external payable {}

    function sendViaTransfer(address payable _to) external payable {
        _to.transfer(123);
    }

    // most don't use sent
    function sendViaSend(address payable _to) external payable {
        bool sent = _to.send(123); // return bools
        require(sent, "send failed");
    }
    
    // recommended way is to use call
    function sendViaCall(address payable _to) external payable {
       (bool success,) = _to.call{value: 123}(""); // amount ether we want to send
       require(success, "call failed");
    }

}

contract EthReceiver {
    event Log(uint amount, uint gas);

    receive() external payable {
        emit Log(msg.value, gasleft());
    }
}