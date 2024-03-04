// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity 0.8.24;

import "./Ownable.sol";

contract Faucet is Ownable {
    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);

    constructor() payable {}

    // Give out ether to anyone who asks
    function withdraw(address recipient, uint withdraw_amount) public onlyOwner {
        // Limit withdrawal amount
        require(withdraw_amount <= 0.1 ether, "MAX_AMOUNT_EXCEEDED");
        require(address(this).balance >= withdraw_amount, "INSUFFICENT_BALANCE");
        
        // Send the amount to the address that requested it
        (bool sent, ) = payable(recipient).call{value: withdraw_amount}("");
        require(sent, "Failed to send Ether");

        emit Withdrawal(recipient, withdraw_amount);
    }

    // function destroy() public {
    //     require(msg.sender == owner, "not owner");
    //     selfdestruct(owner);
    // }

    // Accept any incoming amount
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}