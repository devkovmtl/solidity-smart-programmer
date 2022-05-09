// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// insert, update, read from array of structs
// not a really a smart contract
contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }

    Todo[] public todos;

    function create(string calldata _text) external {
        todos.push(Todo(_text, false));
    }

    function updateText(uint _index, string calldata _text) external {
        // if we have only one field in struct 
        // cheap way to update it
        todos[_index].text = _text;

        // if we have multiple fields to update this is cheaper
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    function get(uint _index) external view returns(string memory, bool){
        // storage - 29397
        // memory - 29480
        Todo storage todo = todos[_index]; // save gas
        return (todo.text, todo.completed);
    }

    function toggleCompleted(uint _index) external {
        todos[_index].completed = !todos[_index].completed;
    }
}