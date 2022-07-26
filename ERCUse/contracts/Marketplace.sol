// SPDX-License-Identifer: MIT
pragma solidity ^0.8.13;

import "@oppenzeppelin/contracts/token/ERC721/IERC721.sol";


contract Marketplace{
    address public owner;
    uint public idForSale;
    //we will use this to store the list of products
    struct ItemForSale{
        address contractAddress;
        address seller;
        address buyer;
        uint256 price;
        uint256 tokenId;
        bool state;

    }
    struct ItemForAction{
        address contractAddress,
        address seller;
        address buyer;
        uint startingPrice;
        uint tokenId;
        uint highlestBid;
        uint deadline;
        bool state;
    }
    //We will use a mapping to store the items for sale
    mapping(uint256 => ItemForSale) public itemsForSale;
    mapping(uint256 => ItemForAction) public itemsForAction;
    constructor(){
        owner = msg.sender;
    }
    //We will use this function to create a new product
    function startNftSale(address _contractAddress, uint _price, uint _tokenId) public {
        IERC721 NFT = IERC721(_contractAddress);
        require(NFT.ownerOf(_tokenId) == msg.sender,"You are not owner of this NFT");
        NFT.transferFrom(msg.sender, address(this), _tokenId);
        require(NFT.ownerOf(_tokenId) == address(this));
        itemsForSale[idForSale] = ItemForSale(_contractAddress, msg.sender, address(0), _price, _tokenId, false);
        idForSale++;
    }
    
    function cancelNftSale(uint Id) public {
        ItemForSale memory item = itemsForSale[Id];
        IERC721 NFT = IERC721(item.contractAddress);
        require(item.seller == msg.sender, "You are not the seller");
        require(item.state == false, "This item is already sold");
        NFT.transferFrom(address(this), item.seller, item.tokenId);
        itemsForSale[Id]=ItemForSale(address(0), address(0), address(0), 0, 0, true);))    
    }

    

    function startNftAuction(address _addressContract,uint _startingPrice, uint _tokenId, uint _deadline) public {
        IERC721 NFT = IERC721(_addressContract);
        require(NFT.ownerOf(_tokenId) == msg.sender,"You are not owner of this NFT");
        NFT.transferFrom(msg.sender, address(this), _tokenId);
        require(NFT.ownerOf(_tokenId) == address(this));
        itemsForAction[idForAction] = ItemForAction(_addressContract, msg.sender, address(0), _startingPrice, _tokenId,0, _deadline, false);
        idForAction++;
    }

    }

    function cancelNftAuction(uint Id){
        ItemForAction memory item = itemsForAction[Id];
        IERC721 NFT = IERC721(item.contractAddress);
        require(Id < idForAction, "This item is not in the list");
        require(item.seller == msg.sender, "You are not the seller");
        require(item.state == false, "This item is already sold");
        NFT.transferFrom(address(this), item.seller, item.tokenId);
        itemsForAction[Id]=ItemForAction(address(0), address(0), address(0), 0, 0, 0, 0, true);

    }

    //We will use this function to buy a product
    function BuyNft(uint Id){
        ItemForSale storage item = itemsForSale[Id];
        require(item<idForSale, "This item is not for sale");
        require(msg.sender!=item.seller, "You are the seller");
        require(item.state == false, "This item is already sold");
        require(item.price > msg.value, "You don't have enough money");
        require(item.buyer == address(0), "This item is already bought");
        IERC721 NFT = IERC721(item.contractAddress);
        NFT.transferFrom(address(this), item.seller, item.tokenId);
        uint price = msg.value*95/100;
        item.buyer = msg.sender;
        payable(item.seller).transfer(price);
        payable(owner).transfer(msg.value-price);
        itemsForSale[Id]=ItemForSale(address(0), address(0), msg.sender, 0, 0, true);
        

    }
    
    function bid(){

    }
    
    function finishAuction(){


    }
}