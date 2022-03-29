// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract ReentrancyGuarded {

    bool reentrancyLock = false;
    modifier reentrancyGuard {
        if (reentrancyLock) {
            revert();
        }
        reentrancyLock = true;
        _;
        reentrancyLock = false;
    }

}
