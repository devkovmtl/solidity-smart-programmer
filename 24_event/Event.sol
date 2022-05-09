// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Event allow us to write data on the blockchain 
// this data cannot be retrieved by smart contract 
// main purpose log something has happened
contract Event {
    event Log(string message, uint val);
    // if we want to look for a particular event we use the keyword index
    // up to 3 params can be indexed
    event IndexedLog(address indexed sender, uint val);

    // not view or pure
    function example() external {
        emit Log("foo", 123);
        emit IndexedLog(msg.sender, 789);
    }

    event Message(address indexed _from, address indexed _to, string message);

    function sendMessage(address _to, string calldata _message) external {
        emit Message(msg.sender, _to, _message);
    }
}