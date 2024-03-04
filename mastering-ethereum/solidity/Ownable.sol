// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity 0.8.24;

error NotOwner();

contract Ownable {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    // Access control modifier
    // tx cost: 24676 gas
    modifier onlyOwner {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    // tx cost: 24427 gas
    modifier onlyOwnerAssert() {
        assert(msg.sender == owner);
        _;
    }

    // tx cost: 24427 gas
    modifier onlyOwnerCustomErr() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }
}