// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
Fallback executed when
- function doesn't exist inside contract
- directly send ETH
 */

contract Faalback {
    event Log(string func, address sender, uint value, bytes data);

    // executed when we try to call a function that does not exist
    // mostly used to receive ETH 
    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    // when msg.data empty
    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }
}