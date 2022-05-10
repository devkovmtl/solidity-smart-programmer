// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
A calls B, sends 100 wei
        B calls C, sends 50 wei
A --> B --> C
            msg.sender = B
            msg.value = 50
            execute code on C's state variables
            use ETH in C

A calls B, sends 100 wei
        B delegatecall C
A --> B --> C
            msg.sender = A delegatecall preserve the context
            msg.value = 100
            execute code on B's state variables
            use ETH in B
*/

contract TestDelegateCall {
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

// using delegeatecall we can update the code 
contract DelegateCall {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test, uint _num) external payable {
        // _test.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
        // same as:
        (bool success, bytes memory data)= _test.delegatecall(abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num));
        require(success, "delegatecall failed");
    }

}
