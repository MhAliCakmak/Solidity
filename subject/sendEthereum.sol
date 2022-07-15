//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank{
    mapping(address => uint256) balances;

    function sendEtherToContract() payable external{
        balances[msg.sender] = msg.value;

    }

    function showBalance() external view returns(uint256){
        return balances[msg.sender];
    }

    function withdraw(address payable _to, uint256 _amount) external {
        require(balances[msg.sender]> _amount,"Dont enough balance");
        _to.transfer(_amount);
        balances[msg.sender]-=_amount;
    }
}
