// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// difference is that view function can read data from blockchain
// where has pure function dont read anything from blockchain
contract ViewAndPureFunctions {
    uint public num;

    // doesn't modify any state variable or write anything to blockchain
    function viewFunc() external view returns (uint) {
        return num;
    }

    // doesn't modify any state variable or write anything to blockchain
    function pureFunc() external pure returns (uint) {
        return 1;
    }

    // read state from smarcontract (num) view function
    function addToNum(uint x) external view returns (uint) {
        return num + x;
    } 

    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }
}