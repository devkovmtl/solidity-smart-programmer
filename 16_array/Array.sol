// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// array can be dynamic or fixed size
// insert(push), get ,update, delete, pop, length
// creating array in memory
contract Array {
    // dynamic means that the size of array can change
    uint[] public nums = [1, 2, 3];
    // fixed means that the size of array can not change
    uint[3] public numsFixed = [4, 5, 6];

    function examples() external {
        nums.push(4); // [1, 2, 3, 4]
        uint x = nums[1];
        // update
        nums[2] = 10;
        // delete length same the size
        delete nums[1]; // [1, 0, 10, 4]
        nums.pop(); // remove last element [1,0,10]
        uint length = nums.length;

        // create in memory fixed size
        uint[] memory nums2 = new uint[](5);
     }

    // return array from function is not recommended
    // reason similar to for loop small 
    // bigger array more gas if array to big can use all of the gas
    // function will not be useable
     function returnArray() external view returns (uint[] memory) {
         return nums;
     }
} 