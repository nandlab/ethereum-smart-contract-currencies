// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "remix_tests.sol"; 
import "remix_accounts.sol";
import "../contracts/DDCoin.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract DDCoinTest is Ownable, ReentrancyGuard {
    DDCoin private ddCoin;

    constructor() Ownable(msg.sender) {}

    function beforeAll() external onlyOwner nonReentrant {
        ddCoin = new DDCoin();
        Assert.equal(ddCoin.queryOwnBalance(), 0, "Initial DDCoin balance should be zero");
    }

    function _mintSomeCoins() internal {
        uint balance = ddCoin.queryOwnBalance();
        ddCoin.mintCoins(100);
        uint newBalance = ddCoin.queryOwnBalance();
        Assert.equal(newBalance - balance, 100, "100 coins should be minted");
    }

    function mintSomeCoins() external onlyOwner nonReentrant {
        _mintSomeCoins();
    }

    function sendSomeCoinsToAnotherAccount() external onlyOwner nonReentrant {
        _mintSomeCoins();
        address anotherAccount = TestsAccounts.getAccount(1);
        uint balance = ddCoin.queryOwnBalance();
        ddCoin.transferCoins(anotherAccount, 50);
        uint newBalance = ddCoin.queryOwnBalance();
        Assert.equal(balance - newBalance, 50, "50 coins should have been deposited");
    }
}
