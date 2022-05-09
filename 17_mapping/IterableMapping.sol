// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// if we have an array we can get the size of an array
// with a for loop we can get all the elements of an array 
// not the case of a mapping
contract IterableMapping {
    mapping(address => uint) public balances;
    // keep track of wether a data is inserted or not
    mapping(address => bool) public inserted;
    // keep track of all key 
    address[] public keys;

    function set(address _addr, uint _val) external {
        balances[_addr] = _val;
        // add the key to the keys array
        if(!inserted[_addr]) {
            inserted[_addr] = true;
            keys.push(_addr);         
        }
    }

    function getSize() external view returns (uint) {
        return keys.length;
    }

    function first() external view returns (uint) {
        return balances[keys[0]];
    }

    function last() external view returns (uint) {
        return balances[keys[keys.length - 1]];
    }

    function get(uint _index) external view returns (uint) {
        return balances[keys[_index]];
    }

}