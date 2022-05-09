// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract CallTestContract {
    // we want to call TestContract
    // _test will be the address of the contract
    // function setX (address _test, uint _x) external {
    //     // call test contract deployed at address _test
    //     TestContract(_test).setX(_x);
    // }
    function setX(TestContract _test, uint _x) external {
        _test.setX(_x);
    }

    function getX(address _test) external view returns (uint x) {
        x = TestContract(_test).getX(); // return x
    }

    function setXAndSendEther(address _test, uint _x) external payable{
        TestContract(_test).setXandReceiveEther{value: msg.value}(_x); // msg.value forward all ether
    }

    function getXAndValue(address _test) external view returns(uint x, uint value){
       ( x,  value) = TestContract(_test).getXandValue(); // return x
    }
}

contract TestContract {
    uint public x;
    uint public value;

    function setX(uint _x) external {
        x = _x;
    }

    function getX() external view returns (uint) {
        return x;
    }

    function setXandReceiveEther(uint _x) external payable {
        x = _x;
        value = msg.value;
    }

    function getXandValue() external view returns (uint, uint) {
        return (x, value);
    }

}