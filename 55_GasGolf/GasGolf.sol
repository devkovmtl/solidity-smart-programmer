// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
// saving gas
contract GasGolf {
    // start - 50908 gas
    // use -  49163 calldata
    // load state variables to memory 48952 gas
    // short circuit expression // 48634 gas
    // loop increments - // 48226 gas instead of i +=1; ++i
    // cache array length // nums.length // 48191 gas
    // load array elements to memory // 48029 gas

    uint public total; // every time we read or write to state vriable we need to pay for gas

    // [1, 2, 3, 4, 5, 100]
    function sumIfEventAndLessThan99(uint[] calldata nums) external {
        uint _total = total;
        uint length = nums.length;
        for(uint i = 0; i < length; ++i) {
            // bool isEven = nums[i] % 2 == 0;
            // bool isLessThan99 = nums[i] < 99;
            // if(isEven && isLessThan99) {
            uint num = nums[i];
            // if(nums[i] % 2 == 0 && nums[i] < 99) {
            //     _total += nums[i]; // every time we read or write to state vriable we need to pay for gas
            // }

            if(num % 2 == 0 && num < 99) {
                _total += num; // every time we read or write to state vriable we need to pay for gas
            }
        }
        total = _total;
    }
}