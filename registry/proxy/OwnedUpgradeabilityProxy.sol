// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "./Proxy.sol";
import "./OwnedUpgradeabilityStorage.sol";

contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {
    
    event ProxyOwnershipTransferred(address previousOwner, address newOwner);
    event Upgraded(address indexed implementation);
    
    function implementation() override public view returns (address) {
        return _implementation;
    }
   
    function proxyType() override public pure returns (uint256 proxyTypeId) {
        return 2;
    }
    
    function _upgradeTo(address implem) internal {
        require(_implementation != implem, "Proxy already uses this implementation");
        _implementation = implem;
        emit Upgraded(implem);
    }
    
    modifier onlyProxyOwner() {
        require(msg.sender == proxyOwner(), "Only the proxy owner can call this method");
        _;
    }
    
    function proxyOwner() public view returns (address) {
        return upgradeabilityOwner();
    }
   
    function transferProxyOwnership(address newOwner) public onlyProxyOwner {
        require(newOwner != address(0), "New owner cannot be the null address");
        emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
        setUpgradeabilityOwner(newOwner);
    }
   
    //重点是下面的 
   
    function upgradeTo(address implem) public onlyProxyOwner {
        _upgradeTo(implem);
    }
   
    function upgradeToAndCall(address implem, bytes memory data) payable public onlyProxyOwner {
        upgradeTo(implem);
        (bool success,) = address(this).delegatecall(data);
        require(success, "Call failed after proxy upgrade");
    }
}
