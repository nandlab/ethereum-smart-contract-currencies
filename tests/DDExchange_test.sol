// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "remix_tests.sol"; 
import "@openzeppelin/contracts/access/Ownable.sol";

import "../contracts/DDCoin.sol";
import "../contracts/DDToken.sol";
import "../contracts/DDExchange.sol";
import "./DDExchangeDemoUser.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract DDExchangeTest is Ownable, ReentrancyGuard {
    DDCoin private ddCoin;
    DDToken private ddToken;
    DDExchange private ddExchange;
    DDExchangeDemoUser private ddExchangeUser;

    constructor() Ownable(msg.sender) {
        Assert.equal(owner(), msg.sender, "The contract deployer should be the owner");
    }

    /// #value: 1000
    function beforeAll() payable external onlyOwner nonReentrant {
        console.log("Preparing DDCoin...");
        Assert.greaterThan(msg.value, uint(999), "Value should be at least 1000 Wei");
        ddCoin = new DDCoin();
        Assert.equal(ddCoin.queryOwnBalance(), 0, "Initial DDCoin balance should be 0");
        ddCoin.mintCoins(1000);
        Assert.equal(ddCoin.queryOwnBalance(), 1000, "After minting, DDCoin balance should be 1000");
        console.log("Done.");
        console.log("Preparing DDToken...");
        ddToken = new DDToken();
        Assert.equal(ddToken.balanceOf(address(this)), ddToken.totalSupply(), "Should own all DDToken initially");
        console.log("Done.");
        console.log("Preparing DDExchange...");
        ddExchange = new DDExchange(address(ddCoin), address(ddToken));
        Assert.equal(ddToken.balanceOf(address(ddExchange)), 0, "The exchange initially should not own anything");
        // Unfortunately, there is no way to check the DDCoin balance of another account
        // The exchange should have no DDCoin at this point
        ddToken.transfer(address(ddExchange), 1000);
        ddCoin.transferCoins(address(ddExchange), 1000);
        Assert.equal(ddToken.balanceOf(address(ddExchange)), 1000, "The exchange should now have 1000 DDToken units");
        // The exchange should have 1000 DDCoin units at this point
        console.log("Exchange service is loaded up with 1000 units of the custom currencies and is ready to use");

        console.log("Creating a new exchange user and giving him all the Wei...");
        ddExchangeUser = new DDExchangeDemoUser{value: address(this).balance}(payable(address(ddExchange)));
        console.log("Done.");
    }

    function exchangeEtherToDDCoin() external onlyOwner nonReentrant {
        ddExchangeUser.buyDDCoin(100);
    }

    function exchangeEtherToDDToken() external onlyOwner nonReentrant {
        ddExchangeUser.buyDDToken(100);
    }
}
