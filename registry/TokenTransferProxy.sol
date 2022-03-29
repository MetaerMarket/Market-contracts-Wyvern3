// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "../@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ProxyRegistry.sol";

contract TokenTransferProxy {

    ProxyRegistry public registry;
    function transferFrom(address token, address from, address to, uint amount)  public returns (bool){
        require(registry.contracts(msg.sender));
        return IERC20(token).transferFrom(from, to, amount);
    }

}
