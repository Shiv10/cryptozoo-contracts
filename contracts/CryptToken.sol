// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CryptToken is ERC20 {

    constructor(uint intialSupply) ERC20("CryptToken", "CRP") {
        _mint(msg.sender, intialSupply * (10 ** decimals()));
    }
}