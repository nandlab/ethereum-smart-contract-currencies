// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DDCoin
 * @dev Custom digital currency
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract DDCoin is Ownable {
    mapping (address => uint) private addressToBalance;

    constructor() Ownable(msg.sender) {}

    function queryOwnBalance() external view returns (uint) {
        return addressToBalance[msg.sender];
    }

    function _transfer(address _from, address _to, uint _amount) internal {
        // Check if the sender has enough balance for the transfer
        require(addressToBalance[_from] >= _amount);
        addressToBalance[_from] -= _amount;
        addressToBalance[_to] += _amount;
    }

    function transferCoins(address _receiver, uint _amount) external {
        _transfer(msg.sender, _receiver, _amount);
    }

    function mintCoins(uint _amount) external onlyOwner {
        addressToBalance[msg.sender] += _amount;
    }
}
