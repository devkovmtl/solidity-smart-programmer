// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/IERC20.sol
interface IERC20 {
    // total amount of this ERC20 token
    function totalSupply() external view returns (uint);
    // return the amount of this ERC20 token has
    function balanceOf(address account) external view returns (uint);
    // holder can call transfer to transfer his ERC20 token over to recipient
    function transfer(address recipient, uint amount) external returns (bool);
    // give us how much a spender is allow to spend
    function allowance(address owner, address spender) external view returns (uint);
    // allow another spender to send his token on behalf of the owner. will call the 
    // function approve to spend some token
    function approve(address spender, uint amount) external returns (bool);
    // after being approve the spender call transferfrom
    // transfering from older to another recipient
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

// crowd fund ERC20 token
contract CrowdFund {
    event Launch(uint id, address indexed creator, uint goal, uint32 startAt, uint32 endAt);
    event Cancel(uint id); // campaignid
    event Pledge(uint id, address indexed caller, uint amount);
    event Unpledge(uint id, address indexed caller, uint amount);
    event Claim (uint id);
    event Refund(uint indexed id, address indexed caller, uint amount);

    struct Campaign {
        address creator;
        uint goal;
        uint pledge; // total amount of token pledge to this token
        uint32 startAt;
        uint32 endAt;
        bool claimed; 
    }

    // only one token is supported
    IERC20 public immutable token;
    // help generate unique id for each campaign
    uint public count;
    // id of campaing => campaign 
    mapping(uint => Campaign) public campaigns;
    // how much each user has pledge to the campaign
    // campaingID => user => amount
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    // goal amount of money they want to raise
    // when campain start and end
    function launch (
        uint _goal,
        uint32 _startAt,
        uint32 _endAt
    ) external {
        require(_startAt >= block.timestamp, "start at < now");
        require(_endAt >= _startAt,  "end at < start at");
        require(_endAt <= block.timestamp + 90 days, "end at > max duration");

        count += 1;
        campaigns[count] = Campaign({creator: msg.sender, goal:_goal, pledge:0, startAt:_startAt, endAt:_endAt, claimed:false});

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    // campaign creator will be able to cancel the campain
    function cancel(uint _id) external {
        // campaign must exist
        // only campaign creator can cancel
        // campaign should not have started yet
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp < campaign.startAt, "started");
        delete campaigns[_id];
        emit Cancel(_id);
    }

    // user pledge to this campaign specify the amount of token they will send
    function pledge(uint _id, uint _amount) external {
        // storage because update
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "not started");
        require(block.timestamp <= campaign.endAt, "ended");
        campaign.pledge += _amount;

        // pledge holds the total amount of token that has been transfer 
        // for this campaign when campaign end if unsuccessful
        // user need to be able to withdraw token pledge
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);

    }

    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "ended");
        // transfer 
        campaign.pledge -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
        emit Unpledge(_id, msg.sender, _amount);
    }

    // if the campaing is over and the amount raised is equal or greater than the goal
    // campaign creator will be able to claim the pledge
    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledge >= campaign.goal, "pledged < goal");
        require(!campaign.claimed, "claimed");

        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledge); //campaign.pledge: total amount
        emit Claim(_id); 
    }

    // user will be able to refund
    function refund(uint _id) external {
        // if found less than the campaign goal user can refund
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledge < campaign.goal, "pledged > goal");

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0; // reset balance before transfer prevent reentrance attack
        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);
    }
}