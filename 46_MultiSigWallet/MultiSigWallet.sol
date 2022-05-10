// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MultiSigWallet {
    // when eth is deposit into multi sig wallet
    event Deposit(address indexed sender, uint amount);
    // when transaction is submited waiting for other signers to sign
    event Submit(uint indexed txId);
    // other owner will be able to approve the transaction 
    event Approve(address indexed owner, uint indexed txId);
    // revoke the transaction
    event Revoke(address indexed owner, uint indexed txId);
    // when sufficient amount of approval is received, the transaction will be executed
    event Execute(uint indexed txId);

    // store the transaction
    struct Transaction {
        address to; // where the transaction is executed
        uint value; // amount of ether to be transferred
        bytes data; // data to be send to to address
        bool executed; // is the transaction executed
    }

    address[] public owners;
    // quick way to check msg.sender is owner
    mapping(address => bool) public isOwner;
    // when transaction is submitted to contract other owner have to approve
    // stored the number of approval needed
    uint public required;

    Transaction[] public transactions;
    // each transaction can be executed if the number of approval is >= required
    // store each approval for each transaction in mapping
    mapping(uint => mapping(address => bool)) public approvals;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExist(uint txId) {
        require(txId < transactions.length, "txId does not exist");
        _;
    }
    
    modifier notApproved(uint txId) {
        require(!approvals[txId][msg.sender], "already approved");
        _;
    }

    modifier notExecuted(uint txId) {
        require(!transactions[txId].executed, "already executed");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owners required");
        require(_required > 0 && _required <= _owners.length, "invalid required number of owners");
        // save the owners to state variable
        for(uint i; i < owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "invalid owner");
            // make sure owner is unique
            require(!isOwner[owner], "owner is already added");
            
            isOwner[owner] = true;
            // store the owner to state variable
            owners.push(owner);
        }
        // save the required number of approval to state variable
        required = _required;
    }

    // receive ether 
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // only the owners will be able to submit a transaction 
    // once transaction has enough approval any of owner can execute the transaction
    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({to: _to, value: _value, data: _data, executed: false}));
        emit Submit(transactions.length - 1); // transactions index
    }

    // once submit
    // other owner can approve the transaction
    function approve(uint _txId) external onlyOwner txExist(_txId) notApproved(_txId) notExecuted(_txId) {
        approvals[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function _getApprovalCount(uint _txId) private view returns (uint count) {
        for(uint i ; i < owners.length ; i ++) {
            if(approvals[_txId][owners[i]]) {
                count++;
            }
        }
    }

    // execute transaction
    function execut(uint _txId) external txExist(_txId) notExecuted(_txId) {
        require(_getApprovalCount(_txId) >= required, "approvals < required");
        Transaction storage transaction = transactions[_txId];

        transaction.executed = true;
        (bool success,) = transaction.to.call{value:transaction.value}(transaction.data);
        require(success, "transaction failed");
        emit Execute(_txId);
    }

    // revoke transaction
    // before transaction is executed, owner can revoke the transaction
    function revoke(uint _txId) external onlyOwner txExist(_txId) notExecuted(_txId) {
        require(approvals[_txId][msg.sender], "not approved"); // make sure the transaction was approved
        approvals[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }
}