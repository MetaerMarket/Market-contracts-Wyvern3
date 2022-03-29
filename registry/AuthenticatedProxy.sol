// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "./ProxyRegistry.sol";
import "../common/TokenRecipient.sol";
import "./proxy/OwnedUpgradeabilityStorage.sol";

contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {

    bool initialized = false;
    address public user;
    ProxyRegistry public registry;
    bool public revoked;
    enum HowToCall { Call, DelegateCall }
    event Revoked(bool revoked);
    function initialize (address addrUser, ProxyRegistry addrRegistry) public {
        require(!initialized, "Authenticated proxy already initialized");
        initialized = true;
        user = addrUser;
        registry = addrRegistry;
    }
   //Set the revoked flag (allows a user to revoke ProxyRegistry access)
    function setRevoke(bool revoke) public{
        require(msg.sender == user, "Authenticated proxy can only be revoked by its user");
        revoked = revoke;
        emit Revoked(revoke);
    }
    //Execute a message call from the proxy contract
    function proxy(address dest, HowToCall howToCall, bytes memory data) public  returns (bool result){
        require(msg.sender == user || (!revoked && registry.contracts(msg.sender)), "Authenticated proxy can only be called by its user, or by a contract authorized by the registry as long as the user has not revoked access");
        bytes memory ret;
        if (howToCall == HowToCall.Call) {
            (result, ret) = dest.call(data);
        } else if (howToCall == HowToCall.DelegateCall) {
            (result, ret) = dest.delegatecall(data);
        }
        return result;
    }
    //Execute a message call and assert success
    function proxyAssert(address dest, HowToCall howToCall, bytes memory data) public{
        require(proxy(dest, howToCall, data), "Proxy assertion failed");
    }

}
