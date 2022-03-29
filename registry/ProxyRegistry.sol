// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "../@openzeppelin/contracts/access/Ownable.sol";
import "./OwnableDelegateProxy.sol";
import "./ProxyRegistryInterface.sol";

contract ProxyRegistry is Ownable, ProxyRegistryInterface {
    
    address public override delegateProxyImplementation;
    mapping(address => OwnableDelegateProxy) public override proxies;
    //Contracts pending access. 
    mapping(address => uint) public pending;
    //Contracts allowed to call those proxies. 
    mapping(address => bool) public contracts;
    uint public DELAY_PERIOD = 2 weeks;

    function startGrantAuthentication (address addr) public onlyOwner{
        require(!contracts[addr] && pending[addr] == 0, "Contract is already allowed in registry, or pending");
        pending[addr] = block.timestamp;
    }

    function endGrantAuthentication (address addr) public onlyOwner{
        require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < block.timestamp), "Contract is no longer pending or has already been approved by registry");
        pending[addr] = 0;
        contracts[addr] = true;
    }

    function revokeAuthentication (address addr) public onlyOwner{
        contracts[addr] = false;
    }
    
     function grantAuthentication (address addr) public onlyOwner{
        contracts[addr] = true;
    }
   
    function registerProxyOverride() public returns (OwnableDelegateProxy proxy){
        proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));
        proxies[msg.sender] = proxy;
        return proxy;
    }
    
    function registerProxyFor(address user) public returns (OwnableDelegateProxy proxy){
        require(address(proxies[user]) == address(0), "User already has a proxy");
        proxy = new OwnableDelegateProxy(user, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", user, address(this)));
        proxies[user] = proxy;
        return proxy;
    }
    
     function registerProxy() public returns (OwnableDelegateProxy proxy){
        return registerProxyFor(msg.sender);
    }

    function transferAccessTo(address from, address to) public{
        OwnableDelegateProxy proxy = proxies[from];
        /* CHECKS */
        require(msg.sender == from, "Proxy transfer can only be called by the proxy");
        require(address(proxies[to]) == address(0), "Proxy transfer has existing proxy as destination");
        /* EFFECTS */
        delete proxies[from];
        proxies[to] = proxy;
    }

}