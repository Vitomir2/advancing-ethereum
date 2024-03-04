pragma solidity ^0.4.8;

contract Lotto {
    bool public payedOut = false;
    address public winner;
    uint public winAmount;
    
    // ... extra functionality here

    // Vulnerability - using a send without checking the response.
    // In this example, a winner whose transaction fails (either by running out of gas
    // or by being a contract that intentionally throws in the fallback function) allows
    // payedOut to be set to true regardless of whether ether was sent or not. In this case,
    // anyone can withdraw the winner's winnings via the withdrawLeftOver func.
    function sendToWinner() public {
        require(!payedOut);
        winner.send(winAmount); // to prevent, always check the return value
        // but if possible, always use the transfer function
        payedOut = true;
    }

    function withdrawLeftOver() public {
        require(payedOut);
        msg.sender.send(this.balance);
    }
}
