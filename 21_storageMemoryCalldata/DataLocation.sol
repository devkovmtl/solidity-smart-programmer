// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// when we declare a variable, we can specify the location of the data
// Data location - storage memory or calldata
// storage state variable
// memory load on memory
// calldata likes memory but can only be used for function input
// calldata has potential to save gas
contract DataLocations {
    struct MyStruct {
        uint foo;
        string text;
    }

    mapping(address => MyStruct) public myStructs;
    // value passed has calldata not modifiable save gas when you pass to another function
    function examples(uint[] calldata y, string calldata s) external returns (uint[] memory) {
        myStructs[msg.sender] = MyStruct({foo: 123, text: "Hello"});
        // if we only want to read the data, we can use memory
        MyStruct storage myStruct = myStructs[msg.sender];
        myStruct.text = "World";

        MyStruct memory readOnly = myStructs[msg.sender];
        readOnly.foo = 456; // change is not saved

        _internal(y);

        uint[] memory memeArr = new uint[](3);
        memeArr[0] = 234;
        return memeArr;
    }

    function _internal(uint[] calldata y) private {
        uint x = y[0];
    }
}