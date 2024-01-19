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
    DDToken ddtInterface;
    address ddtAccount;
    DDCoin ddcInterface;

    constructor() Ownable(msg.sender) {}

    function setDdtAccess(address _ddtAddress, address _ddtAccount) external onlyOwner {
        ddtInterface = DDToken(_ddtAddress);
        ddtAccount = _ddtAccount;
    }

    function setDdcAddress(address _ddcAddress) external onlyOwner {
        ddcInterface = DDCoin(_ddcAddress);
    }

    function exchangeEtherToMyCurrency(string calldata _symbol) external payable {
        if (keccak256(abi.encodePacked(_symbol)) == keccak256(abi.encodePacked("DDT"))) {
            // This contract should be approved to transfer tokens from the specified ddtAccount
            ddtInterface.transferFrom(ddtAccount, msg.sender, msg.value);
        }
        else if (keccak256(abi.encodePacked(_symbol)) == keccak256(abi.encodePacked("DDC"))) {
            // This contract should be registered as the approvedExchange
            ddcInterface.transferOwnerCoins(msg.value, msg.sender);
        }
    }
}
