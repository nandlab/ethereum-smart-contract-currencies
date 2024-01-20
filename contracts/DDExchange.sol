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
    DDCoin public ddCoin;
    DDToken public ddToken;

    constructor(address _ddCoinAddr, address _ddTokenAddr) payable Ownable(msg.sender) {
        ddCoin = DDCoin(_ddCoinAddr);
        ddToken = DDToken(_ddTokenAddr);
    }

    enum CurrencyType {
        DDCoin,
        DDToken
    }

    function exchangeEtherToDDCurrency(CurrencyType _currencyType) external payable {
        // This contract should already own enough DDCoin or DDToken for this exchange to work.
        if (_currencyType == CurrencyType.DDToken) {
            ddToken.transfer(msg.sender, msg.value);
        }
        else /* _currencyType == CurrencyType.DDCoin */ {
            ddCoin.transferCoins(msg.sender, msg.value);
        }
    }
}
