// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../contracts/DDExchange.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "remix_tests.sol"; 
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract DDExchangeDemoUser is Ownable, ReentrancyGuard {
    DDExchange private ddExchange;

    constructor(address payable _ddExchangeAddr) payable Ownable(msg.sender) {
        ddExchange = DDExchange(_ddExchangeAddr);
        Assert.equal(ddExchange.ddCoin().queryOwnBalance(), 0, "I should not have any DDCoin yet");
        Assert.equal(ddExchange.ddToken().balanceOf(address(this)), 0, "I should not have any DDToken yet");
    }

    function buyDDCoin(uint _amount) external onlyOwner nonReentrant {
        console.log("User: Buying DDCoin...");
        uint weiBalance = address(this).balance;
        require(_amount <= weiBalance);
        DDCoin ddCoin = ddExchange.ddCoin();
        uint ddcBalance = ddCoin.queryOwnBalance();
        console.log("User:  Calling exchangeEtherToDDCurrency...");
        ddExchange.exchangeEtherToDDCurrency{value: _amount}(DDExchange.CurrencyType.DDCoin);
        console.log("User:  Done.");
        uint weiNewBalance = address(this).balance;
        uint ddcNewBalance = ddCoin.queryOwnBalance();
        Assert.greaterThan(ddcNewBalance, ddcBalance, "DDC balance should have increased");
        Assert.lesserThan(weiNewBalance, weiBalance, "Wei balance should have decreased");
        Assert.equal(ddcNewBalance - ddcBalance, _amount, "Incorrect amount of DDCoin received");
        Assert.equal(weiBalance - weiNewBalance, _amount, "Incorrect amount of Wei sent");
        console.log("User: Done.");
    }

    function buyDDToken(uint _amount) external onlyOwner nonReentrant {
        console.log("User: Buying DDToken...");
        uint weiBalance = address(this).balance;
        require(_amount <= weiBalance);
        DDToken ddToken = ddExchange.ddToken();
        uint ddtBalance = ddToken.balanceOf(address(this));
        console.log("User:  Calling exchangeEtherToDDCurrency...");
        ddExchange.exchangeEtherToDDCurrency{value: _amount}(DDExchange.CurrencyType.DDToken);
        console.log("User:  Done.");
        uint weiNewBalance = address(this).balance;
        uint ddtNewBalance = ddToken.balanceOf(address(this));
        Assert.greaterThan(ddtNewBalance, ddtBalance, "DDT balance should have increased");
        Assert.lesserThan(weiNewBalance, weiBalance, "Wei balance should have decreased");
        Assert.equal(ddtNewBalance - ddtBalance, _amount, "Incorrect amount of DDToken received");
        Assert.equal(weiBalance - weiNewBalance, _amount, "Incorrect amount of Wei sent");
        console.log("User: Done.");
    }
}
