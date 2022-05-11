// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
// delay transaction so that it gives user some time to react before 
// the transaction is submitted to the blockchain

// commonly used in DAO and DEFI
// purpose is to delay a transaction
// first broadcast a transaction queue()
// define a certain amount a time 
// then execute the transaction
contract TimeLock {
    error NotOwnerError();
    error AlreadyQueuedError(bytes32 txId);
    error TimestampNotInRangeError(uint blockTimeStamp, uint timestamp);
    error NotQueuedError(bytes32 txId);
    error TimestampNotPassedError(uint blockTimeStamp, uint timestamp);
    error TimestampExpiredError(uint blockTimeStamp, uint timestamp);
    error TxFailedError();

    address public owner;
    // if the transaction is already in the queue
    mapping(bytes32 => bool) public queued;
    uint public constant MIN_DELAY = 10;   
    uint public constant MAX_DELAY = 100; // mainet 30 days
    uint public constant GRACE_PERIOD = 100; // 100seconds
    
    event Queue(
        bytes32 indexed txId,
        address indexed target,
        uint value, 
        string func, 
        bytes data, 
        uint timestamp
    );
    
    event Execute(
        bytes32 indexed txId,
        address indexed target,
        uint value, 
        string func, 
        bytes data, 
        uint timestamp
    );

    event Cancel(bytes32 indexed txId);

    receive() external payable {}

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if(msg.sender != owner) {
            revert NotOwnerError();
        }
        _;
    }

    function getTxId(
        address _target, 
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) public pure returns (bytes32 txId){
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }

    function queue(
        address _target, 
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external onlyOwner {
        // create transaction id and make it unique
        // make sur tx id unique
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        // check timestamp
        if(queued[txId]) {
            revert AlreadyQueuedError(txId);
        }
        // ---|------------|---------------|-------
        //  block    block + min     block + max
        if(_timestamp < block.timestamp + MIN_DELAY || _timestamp > block.timestamp + MAX_DELAY) {
            revert TimestampNotInRangeError(block.timestamp, _timestamp);
        }
        // queue tx
        queued[txId] = true;

        emit Queue(txId, _target, _value, _func, _data, _timestamp);
    }

    function execute(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external payable onlyOwner returns (bytes memory){
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        // check tx is queued
        if(!queued[txId]) {
            revert NotQueuedError(txId);
        }
        // checked queued minimum delay
        // check bloc.timestamp > _timestamp
        if(block.timestamp < _timestamp) {
            revert TimestampNotPassedError(block.timestamp, _timestamp);
        }
        // make sure transaction is not expired
         // ----|-------------------|-------
        //  timestamp    timestamp + grace period
        if(block.timestamp > _timestamp + GRACE_PERIOD) {
            revert TimestampExpiredError(block.timestamp, _timestamp + GRACE_PERIOD);
        }
        // delete tx from queue
        queued[txId] = false;
        bytes memory data;
        if(bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
        } else {
            data = _data;
        }
        // execute the tx
        (bool ok, bytes memory res) = _target.call{value:_value}(data);
        if(!ok) {
            revert TxFailedError();
        }

        emit Execute(txId, _target, _value, _func, _data, _timestamp);

        return res;

    }

    // cancel the transaction
    function cancel(
        bytes32 _txId
    ) external onlyOwner {
        if(!queued[_txId]) {
            revert NotQueuedError(_txId);
        }

        queued[_txId] = false;
        emit Cancel(_txId);
    }

}

contract TestTimeLock {
    address public timeLock;

    constructor(address _timeLock) {
        timeLock = _timeLock;
    }

    function test() external {
        require(msg.sender == timeLock);
        // more code here such as 
        // - upgrade contract
        // - transfer funds
        // - switch price oracle
    }

    function getTimestamp() external view returns (uint) {
        return block.timestamp + 100;
    }
}