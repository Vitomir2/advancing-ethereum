// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity 0.8.24;

// Our first contract is a faucet!
contract Faucet {
    address public owner;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Give out ether to anyone who asks
    function withdraw(address recipient, uint withdraw_amount) public onlyOwner {
        // Limit withdrawal amount
        require(withdraw_amount <= 0.1 ether);
        
        // Send the amount to the address that requested it
        (bool sent, ) = payable(recipient).call{value: withdraw_amount}("");
        require(sent, "Failed to send Ether");
    }

    // function destroy() public {
    //     require(msg.sender == owner, "not owner");
    //     selfdestruct(owner);
    // }

    // Accept any incoming amount
    receive() external payable {}
}