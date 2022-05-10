// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// keccak256(x) // use to create signature, unique id, and also
// protect contract // return byte
contract HashFunc {
    function hash(string memory text, uint num, address addr) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text, num, addr)); // input need to be in bytes
    // encodePacked // compress the bytes
    }

    function encode(string memory text0, string memory text1) external pure returns (bytes memory) {
        return abi.encode(text0, text1);
    }

    function encodePacked(string memory text0, string memory text1) external pure returns (bytes memory) {
        return abi.encodePacked(text0, text1);
    }

    function collision(string memory text0, string memory text1, uint x) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text0, x, text1)); // no dynamic data type next to each other
    }

}