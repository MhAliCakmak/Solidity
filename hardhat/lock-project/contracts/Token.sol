// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MASIToken is ERC20 {
    constructor() ERC20("MASIoken", "MASI") {}
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(msg.sender, 1000000*10)**decimals();
    }
}