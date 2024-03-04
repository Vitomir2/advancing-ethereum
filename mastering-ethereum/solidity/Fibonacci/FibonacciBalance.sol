pragma solidity ^0.4.8;

// MAIN vulnerability comes from that the contracts reserve memory slots for the state variables,
// thus, in the library contract for slot[0] and slot[1] we have start and calculatedFibNumber, respectively.
// However, we can see that in this contract at slot[0] we have the fibonacciLibrary variable.
// Therefore, if one call the setStart function using the delegatecall, then it will change
// the slot[0] value to the new start number which actually should be set in slot[2].
// However, since the delegatecall works with the context of this contract, it will
// change the incorrect variable and we gonna have problems in this case.
// Additionally, the withdraw function is likely to revert as it will contain
// uint(fibonacciLibrary) amount of ether, which is what calculatedFibNumber will return.
contract FibonacciBalance {
    address public fibonacciLibrary;
    // the current Fibonacci number to withdraw
    uint public calculatedFibNumber;
    // the starting Fibonacci sequence number
    // vulnerability 1 - this start number value will be considered when executing
    // the function in the fibonacci library
    uint public start = 3;
    uint public withdrawalCounter;
    // the Fibonancci function selector
    bytes4 constant fibSig = bytes4(sha3("setFibonacci(uint256)"));

    // constructor - loads the contract with ether
    function FibonacciBalance(address _fibonacciLibrary) public payable {
        fibonacciLibrary = _fibonacciLibrary;
    }

    function withdraw() {
        withdrawalCounter += 1;
        // calculate the Fibonacci number for the current withdrawal user-
        // this sets calculatedFibNumber
        require(fibonacciLibrary.delegatecall(fibSig, withdrawalCounter));

        msg.sender.transfer(calculatedFibNumber * 1 ether);
    }

    // allow users to call Fibonacci library functions
    function() public {
        // vulnerability 2 - anyone will be able to call setStart from the library contract
        // which can lead to incorrect withdrawal amounts.
        require(fibonacciLibrary.delegatecall(msg.data));
    }
}
