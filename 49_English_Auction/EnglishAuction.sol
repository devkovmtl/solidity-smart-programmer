// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC721 {
    function transferFrom (
        address _from,
        address _to,
        uint _nftId
    ) external;
}

// seller set a starting price and ending time
// the highest bidder win
contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address indexed highestbidder, uint highestbid);

    IERC721 public immutable nft; // address contract
    uint public immutable nftId; 

    address payable public immutable seller; 
    // starting time
    uint32 public endAt; // 100 year

    // state of auction
    bool public started;
    bool public ended;
    // bidders
    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids; // total amount of bids

    constructor(address _nft, uint _nftId, uint _staringBid) {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _staringBid;
    }

    function start() external {
        require(msg.sender == seller, "not seller");
        require(!started, "started");
        started = true;
        endAt = uint32(block.timestamp + 60); // 60 seconds
        nft.transferFrom(seller, address(this), nftId);
        emit Start();
    }

    // once the auction has started user can bid
    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        // check if the bid is higher than the current highest bid
        require(msg.value > highestBid, "value < highest bid");

        // keep track of the amount of bid if not highest give back
        if(highestBidder != address(0)) {
            // keep track of all the bids that were out bid
            bids[highestBidder] += highestBid;
        }
        bids[highestBidder] += highestBid;

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        // if we transfer the eth before we reset the balance 
        // contract will be vulnerable to reentrancy attack
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);
        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "not started");
        require(!ended, "ended");
        require(block.timestamp >= endAt, "not ended");
        ended = true;
        if(highestBidder != address(0)) {
            // transfer the highest bid to the highest bidder
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            // if no bid then transfer the eth to the seller
           nft.transferFrom(address(this),seller, nftId);
        }
        emit End(highestBidder, highestBid);
    }
}