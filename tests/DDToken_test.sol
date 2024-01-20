// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "remix_tests.sol"; 
import "remix_accounts.sol";
import "../contracts/DDToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DDTokenTest is Ownable {
    DDToken private ddToken;

    constructor() Ownable(msg.sender) {}

    function beforeAll() external onlyOwner {
        ddToken = new DDToken();
        Assert.equal(ddToken.totalSupply(), 10**24, "The total supply of DDToken should be 1 million");
        Assert.equal(ddToken.balanceOf(address(this)), ddToken.totalSupply(), "The whole DDToken supply should initially belong to the owner");
    }
}
