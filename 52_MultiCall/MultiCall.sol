// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// We want to make query to a contract call multiple times.
// call multiple function 
// Aggregate multiple query into single function call multicall
contract TestMultiCall {
    function func1() external view returns (uint, uint) {
        return (1, block.timestamp);
    }

    function func2() external view returns (uint, uint) {
        return (2, block.timestamp);
    }

    // data to instruct to call func1 and func2
    function getData1() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.func1.selector);
    }

    function getData2() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.func2.selector);
    }
}

contract MultiCall {
    function multicall(address[] calldata targets, bytes[] calldata data) external view returns(bytes[] memory){
        require(targets.length == data.length, "targets length != data length");
        bytes[] memory results = new bytes[](data.length);
        for(uint i; i < targets.length; i++) {
           (bool success, bytes memory result) = targets[i].staticcall(data[i]);
           require(success, "call failed");
           results[i] = result;
        }
        return results;
    }
}