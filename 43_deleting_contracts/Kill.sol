// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// selfdestruct contract
// - delete contract
// - force send Ether to any address
contract Kill {
    constructor() payable {}

    function kill() external {
        selfdestruct(payable(msg.sender)); // where to send ether to 
    }

    function testCall() external pure returns (uint) {
        return 123;
    }

}

contract Helper {
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function kill(Kill _kill) external {
        _kill.kill();
    }
}