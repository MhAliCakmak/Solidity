//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Mapping{
    //mapping like dictonary index and column you can think in data science 
    mapping(address => bool) public registered;
    mapping(address => uint256) public amount;

    function register(uint256 _amount) public {
        require(!registered[msg.sender],"already have account please check it ...)");
        registered[msg.sender]=true;
        amount[msg.sender] = _amount;
    }

    //if you want delete value in mapping just use delete function 
    function deleteRegist() public {
        require(registered[msg.sender],"You dont have account first please create one account");
        delete(registered[msg.sender]);
        delete(amount[msg.sender]);
    }
}


//good for here .Some time We must nested mapping sample 
contract NestedMapping{
    mapping(address => mapping(address => uint256)) public debts ;

    function inDebt(address _barrower , uint256 _amount) public  {
        debts[msg.sender][_barrower] += _amount;
        
    }

    function decDebt(address _barrower , uint256 _amount) public  {
        require(debts[msg.sender][_barrower] >= _amount,"Not enough debt");
        debts[msg.sender][_barrower] -= _amount;
        
    }

    function getDebt(address _barrower) public view returns(uint256){
        return debts[msg.sender][_barrower];
    }
}
