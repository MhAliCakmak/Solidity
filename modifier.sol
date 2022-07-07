//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


//we will examine struct and enum and Our sample is Order system with solidity

contract StructEnum{

    
    
    
    //use for status of our order
    enum Status {
        Taken,
        Preparing,
        Boxed,
        Shipped
    }
    
    struct Order{
        address customer;
        string zipCode;
        uint256[] products;
        Status status;
    }

    address public owner;

    constructor(){
        owner=msg.sender;
    }

    Order[] public orders;

    function createOrder(string memory _zipCode,uint256[] memory _products) checkProducts(_products) external returns(uint256) {
       
        orders.push(
            Order({
                customer: msg.sender,
                zipCode: _zipCode,
                products: _products,
                status: Status.Taken
            })
        );

        return orders.length -1;

    }

    function advanceOrder(uint256 _orderId) checkId(_orderId) external {
        require(owner == msg.sender,"You are not owner");
        
        
        Order storage order = orders[_orderId];
        require(order.status !=Status.Shipped,"Order is already shipped");

        if (order.status == Status.Taken){
            order.status = Status.Preparing;
        }else if (order.status == Status.Preparing){
            order.status= Status.Boxed;
        }
        else if (order.status == Status.Boxed){
            order.status= Status.Shipped;
        }

    }

    function getOrder(uint256 _orderId) checkId(_orderId) external view returns(Order memory){
        

        return orders[_orderId];
        
    }

    function updateZip(uint256 _orderId, string memory _zip) checkId(_orderId) external{
        
        Order storage order =orders[_orderId];
        require(order.customer == msg.sender,"You are not owner of order");
        order.zipCode = _zip;
    }

    modifier checkProducts(uint256[] memory _products){
        require(_products.length >0 , "Dont have product.");
        _;
      
    }

    modifier checkId(uint256 _orderId){
        require(_orderId<orders.length,"this id unkown");
        _;
    }
}

