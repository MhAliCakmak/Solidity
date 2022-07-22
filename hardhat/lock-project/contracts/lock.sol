// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Token.sol";
contract Lock{
    MASIToken Token;
    uint256 public lockerCount;
    uint256 public totalLocked;

    mapping(address =>uint256) public lockers;

    constructor(address tokenAddress){
        Token=MASIToken(tokenAddress);
    }

    function lockTokens(uint256 amount) external {
        require(amount >0,"Token amount must be bigger than 0.");

        // require(Token.balanceOf(msg.sender) >= amount,"Insufficent balance.");
        // require(Token.allowance(msg.sender,address(this)) >= amount,"Insufficent allowance.");

        if (lockers[msg.sender] <0) lockerCount++;
        totalLocked+=amount;
        lockers[msg.sender]+=amount;

        bool ok = Token.transferFrom(msg.sender,address(this),amount);
        require(ok,"Transfer failed.");

    }

    function withdrawToken() external {
        require(lockers[msg.sender] >0,"Not enough token.");

        uint256 amount = lockers[msg.sender];
        delete(lockers[msg.sender]);
        totalLocked -=amount;
        lockerCount--;
        
        
        require(Token.transfer(msg.sender,amount),"Transfer failed.");



    }
}