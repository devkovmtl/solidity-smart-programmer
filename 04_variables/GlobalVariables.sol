// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// store information such has blockchain transaction, account that called function
contract GlobalVariables {

    // view: read only function, view can read from state variable and globale variable
    function globalVars() external view returns (address, uint, uint) {
        address sender =  msg.sender; // store address that called the function
        uint timestamp = block.timestamp; // unix timestamp of when function was called
        uint blockNumber = block.number; // block number

        return (sender, timestamp, blockNumber);
    }
}