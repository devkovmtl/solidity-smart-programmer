// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// contract Counter {
//     uint public count;

//     function inc() external {
//         count++;
//     }

//     function dec() external {
//         count--;
//     }
// }

// to use a contract without having the code of the contract
// we can use an interface
interface ICounter {
    function count() external view returns (uint);
    function inc() external;
    function dec() external;
}

contract CallInterface {
    uint public count;
    function examples(address _counter) external {
        ICounter(_counter).inc();
        count = ICounter(_counter).count();
    }
}