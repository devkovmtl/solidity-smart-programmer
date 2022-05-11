// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// if we want to preserve the context(ex msg.sender) when we call multical
// we need to use delegatecall

contract MultiDelegateCall {
    error DelegatecallFailed();

    function multiDelegateCall(bytes[] calldata data) external payable returns(bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint i; i < data.length; i++) {
            (bool ok, bytes memory res) = address(this).delegatecall(data[i]);
            if(!ok) {
                revert DelegatecallFailed();
            }
            results[i] = res;
        }
    }
}

contract TestMultiDelegatecall is MultiDelegateCall {
    event Log (address caller, string func, uint i);

    function func1(uint x, uint y) external {
        emit Log(msg.sender, "func1", x + y);
    }

    function func2() external returns (uint) {
        emit Log(msg.sender, "func2", 2);
        return 111;
    }
    mapping(address => uint) public balanceOf;

    // WARNING: unsafe code when used in combination with multi-delegatecall
    // user can mint multiple times for the price of msg.value
    function mint() external payable {
        balanceOf[msg.sender] += msg.value;
    }

}


contract Helper {
    function getFunc1Data(uint x, uint y) external pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegatecall.func1.selector, x, y);
    }

    function getFunc2Data() external pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegatecall.func2.selector);
    }

    function getMintData() external pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegatecall.mint.selector);
    }
}