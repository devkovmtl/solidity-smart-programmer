// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// we can create a contract with create or createto
contract Account {
    address public bank;
    address public owner;

    constructor(address _owner) payable {
        bank = msg.sender;
        owner = _owner;
    }
}

// we want to deploy Account contract
contract AccountFactory { // create new stuff
    Account[] public accounts;

    function createAccount(address _owner) external payable {
        // {amount of ether will be sending}
        Account account = new Account{value:123}(_owner);
        // we want to see address of account
        accounts.push(account);
    }
}