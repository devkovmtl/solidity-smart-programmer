// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Dutch auction is an auction where the seller set a price at the start of the auction
// and the price goes down over time
// when the buyer decide the price is low enough, he buy the item

// expensive fashion clothes that go on sale
interface IERC721 {
    function transferFrom (
        address _from,
        address _to,
        uint _nftId
    ) external;
}

// we are going to write a dutch auction for a NFT
contract DutchAuction {
    uint private constant DURATION = 7 days;
    // need NFT address and NFT id 
    IERC721 public immutable nft; // address not change the NFT
    uint public immutable nftId; 

    address payable public immutable seller; // seller address

    uint public immutable startingPrice; // starting price
    uint public immutable startAt;
    uint public immutable expiresAt;

    uint public immutable discountRate; 

    constructor(uint _startingPrice, uint _discoutRate, address _nft, uint _nftId) public {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discoutRate;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        
        // check price greather than 0
        require(_startingPrice >= discountRate * DURATION, "starting price < discount");
        
        nft = IERC721(_nft);
        nftId = _nftId;
        
    }

    // get current price of nft
    function getPrice() public view returns (uint) {
        uint timeElapsed = block.timestamp - startAt; 
        uint discount = discountRate * timeElapsed; 
        return startingPrice - discount;
    }

    function buy() external payable {
        require(block.timestamp < expiresAt, "auction expired");
        uint price = getPrice();
        require(msg.value >= price, "ETH < price");
        nft.transferFrom(seller, msg.sender, nftId);
        uint refund = msg.value - price;
        // if send more thant price
        if(refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        // delete the contract
        selfdestruct(seller); // send all eth to seller and delete the contract 
    }

}