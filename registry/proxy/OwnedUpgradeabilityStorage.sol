// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract OwnedUpgradeabilityStorage {

    address internal _implementation;
    address private _upgradeabilityOwner;
    
    function upgradeabilityOwner() public view returns (address) {
        return _upgradeabilityOwner;
    }

    function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
        _upgradeabilityOwner = newUpgradeabilityOwner;
    }
}
