// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity 0.8.24;

// Our first contract is a faucet!
contract Faucet {
    // Give out ether to anyone who asks
    function withdraw(uint withdraw_amount) public {
        // Limit withdrawal amount
        require(withdraw_amount <= 100000000000000000);
        
        // Send the amount to the address that requested it
        (bool sent, ) = payable(msg.sender).call{value: withdraw_amount}("");
        require(sent, "Failed to send Ether");
    }

    // Accept any incoming amount
    receive() external payable {}
}