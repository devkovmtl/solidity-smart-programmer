// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ForAndWhileLoops {
    function loops() external pure {
        for(uint i = 0; i < 10; i++) {
            // code
            if(i == 3) {
                continue;
            }
            // to get out of the loop break
            if(i == 6) {
                break;
            }
        }
        
        uint j = 0;
        while(j < 10) {
            // code
            j++;
        }
    }

    // bigger number of loop more gas it will use it
    function sum(uint _n) external pure returns (uint) {
        uint s = 0;
        for(uint i = 1; i < _n; i++) {
            s += i;
        }
        return s;
    }
}