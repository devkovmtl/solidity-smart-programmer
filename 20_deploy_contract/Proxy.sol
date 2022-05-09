// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract TestContract1 {
    address public owner = msg.sender;

    function setOwner( address _owner) public {
        require(msg.sender == owner, "not owner");
        owner = _owner;
    }
}

contract TestContract2 {
    address public owner = msg.sender;
    uint public value = msg.value;
    uint public x;
    uint public y;

    constructor (uint _x, uint _y)  payable {
        x = _x;
        y = _y;
    }
}

contract Proxy {
    event Deploy(address);

    fallback() external payable {}

    // we want ot be able to deploy any contract by calling this function 
    // without having the need to modify TestContract1 to TestContract2 etc...
    function deploy(bytes memory _code) external payable  returns (address addr){
        // new TestContract1();
        // to deploy an arbitrary contract we need assembly
        assembly {
            // create(v,p,n)
            // v: amount of ETH to send
            // p: pointer in memory to start code
            // n: size of code
            // v: inside assembly msg.value don't work
            // p: where does our code start in memory _code is loading first 32
            // bytes encode the length of code skip 32bytes
            // n: store in first 32 bytes
            addr := create(callvalue(), add(_code, 0x20), mload(_code))
        }

        // check if addr return is not 0 addr if it error
        require(addr != address(0), "deploy failed");
        // emit event
        emit Deploy(addr);
    }

    // to be able to call any function from proxy:
    function execute(address _target, bytes memory _data) external payable {
        (bool success, ) = _target.call{value: msg.value}(_data);

        // check if success is true
        require(success, "failed");
    }
}

contract Helper {
    function getByteCode1() external pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract1).creationCode;
        return bytecode;
    }
    
    function getByteCode2(uint _x, uint _y) external pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract1).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_x, _y));
    }
    
    function getCalldata(address _owner) external pure returns (bytes memory) {
        return abi.encodePacked("setOwner(address)", _owner);
    }
}