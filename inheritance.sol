//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A{
    uint public x;

    uint public y;

    function setX(uint _x) virtual public{
        x=_x;
    }
     function setY(uint _y) public{
        y=_y;
    }
}

//override

contract B is A{
    uint public z;
    function setZ(uint _z)public {
        z=_z;
    }

    function setX(uint _x) override public{
        x=2*_x;
    }
}

contract Human {
    function sayHello() public pure virtual returns(string memory){
        return "hello";
    }
}

contract SuperHuman is Human{
    function sayHello() public pure override returns(string memory){
        return super.sayHello();
    }
}
