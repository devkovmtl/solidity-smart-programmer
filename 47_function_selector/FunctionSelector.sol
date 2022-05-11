// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract FunctionSelector {
    function getSelector(string calldata _func) external pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}

// what data is being passed when we call the function transfer? 
contract Receiver {

    event Log(bytes data);

    function transfer(address _to, uint _amount) external {
        emit Log(msg.data); // first 4 bytes encode the function to call
        // rest data to pass
    }
}