// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DDToken
 * @dev An ERC20 token implementation with a fixed supply of 1 million units
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract DDToken is ERC20, ERC20Permit {
    constructor() ERC20("DDToken", "DDT") ERC20Permit("DDToken") {
        _mint(msg.sender, 10**(6 + decimals()));
    }
}
