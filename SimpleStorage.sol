//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage{

    struct People{
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;

    mapping(string => uint256) public nameTFavoriteNumber;
    //this will get initalized to 0
    uint256 public favoriteNumber;

    function store(uint256 _favoriteNumber) public{
        favoriteNumber = _favoriteNumber;

    }

    //view , 
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    function addPerson(string memory _name,uint256 _favoriteNumber)public{
        people.push(People(_favoriteNumber,_name));
        nameTFavoriteNumber[_name] = _favoriteNumber;
    }
}
