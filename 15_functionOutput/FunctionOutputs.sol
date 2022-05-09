// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Return multiple outputs
// Names outputs
// Destructuring Assignment

contract FunctionOutputs {
    // function that can return multiple outputs
    function returnMany() public pure returns (uint, bool){
        return (1, true);
    }

    // function named outputs
    function returnNamed() public pure returns (uint x, bool b) {
        return (1, true);
    }

    function assigned() public pure returns (uint x, bool b) {
        // return like that save gas
        x = 1;
        b = true;
    }

    function destructuringAssignments() public pure {
        // capture the outputs in variables
        (uint x, bool b) = returnMany();
        (, bool f) = returnMany(); // grab the second output
    }
}