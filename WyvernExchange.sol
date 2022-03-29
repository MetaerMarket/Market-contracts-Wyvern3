// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "./exchange/Exchange.sol";

contract WyvernExchange is Exchange {

    string public constant name = "Wyvern Exchange";
  
    string public constant version = "3.1";

    string public constant codename = "Ancalagon";

    //constructor (uint chainId, address[] memory registryAddrs, string memory customPersonalSignPrefix){
    constructor (uint chainId, address[] memory registryAddrs){
        DOMAIN_SEPARATOR = hash(EIP712Domain({
            name              : name,
            version           : version,
            chainId           : chainId,
            verifyingContract : address(this)
        }));
        for (uint i = 0; i < registryAddrs.length; i++) {
          registries[registryAddrs[i]] = true;
        }
    }
}