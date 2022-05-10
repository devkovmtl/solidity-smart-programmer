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

contract ERC20 is IERC20 {
    // total amount of this ERC20 token
    uint public totalSupply; // mint token total increase, burn token total decrease
    // how much each user has token
    mapping(address => uint) public balanceOf;

    // track who is allowed to spend token
    // owner => spender => amount
    mapping(address => mapping(address => uint)) public allowance;

    // metadata about ERC20
    string public name = "Test";
    string public symbol = "TEST";
    uint8 public decimals = 18; // how many zero used to represent 1 token / 10**18 = 1 token

    // transfer the amount of token over to another recipient 
    function transfer(address recipient, uint amount) external returns (bool) {
        // update balanceof
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        // emit the event(sender, recipient, amount)
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // msg sender will be allowed to approved a spender to spend some balance
    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        // deducted the allowance 
        allowance[sender][msg.sender] -= amount;
        // update balanceof
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // mint token to the owner create token
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        // from address 0 send to sender the amount
        emit Transfer(address(0), msg.sender, amount);
    }

    // destroy token
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}