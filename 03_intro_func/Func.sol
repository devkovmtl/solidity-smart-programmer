// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FunctionIntro {
    // external: means when deploy will be accessible to other contracts 
    // pure: means read only do not write anything to blockchain
    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }

    function sub(uint x, uint y) external pure returns (uint) {
        return x - y;
    }
}