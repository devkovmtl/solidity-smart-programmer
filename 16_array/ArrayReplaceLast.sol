// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// remove array element by shifting elements to the left
// [1,2,3,4,5] -> remove(2) -> [1,2,4,5,5] -> [1,2,4,5] // not very gas efficient
contract ArrayReplaceLast {
    uint[] public arr;

    // [1,2,3,4] -> remove(1) -> [1,4,3]
    // [1,4,3] -> remove(2) -> [1,4]
    function remove(uint _index) public {
        arr[_index] = arr[arr.length - 1];
        arr.pop();
    } 

    function test() external {
        arr = [1,2,3,4];
        remove(1);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);

        remove(2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }
}