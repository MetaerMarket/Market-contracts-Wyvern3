// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "../@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenLocker {
    
    address public owner;
    address public token=address(0);

    constructor (address tokenAddr){
        owner = msg.sender;
        token = tokenAddr;
    }

    function transfer(address dest, uint amount) public returns (bool) {
        require(msg.sender == owner);
        return IERC20(token).transfer(dest, amount);
    }

}
