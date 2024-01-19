// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./DDCoin.sol";
import "./DDToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DDExchange
 * @dev An exchange contract where users can deposit Ether and receive DDCoins or DDTokens
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract DDExchange is Ownable {
    DDCoin private ddCoin;
    DDToken private ddToken;

    constructor(address _ddCoinAddr, address _ddTokenAddr) payable Ownable(msg.sender) {
        ddCoin = DDCoin(_ddCoinAddr);
        ddToken = DDToken(_ddTokenAddr);
    }

    enum CurrencyType {
        DDCoin,
        DDToken
    }

    function exchangeEtherToMyCurrency(CurrencyType _currencyType) external payable {
        if (_currencyType == CurrencyType.DDToken) {
            // This contract should be approved to transfer tokens from the specified ddtAccount
            ddToken.transferFrom(address(this), msg.sender, msg.value);
        }
        else /* _currencyType == CurrencyType.DDCoin */ {
            // This contract should be registered as the approvedExchange
            ddCoin.transferCoins(msg.sender, msg.value);
        }
    }
}
