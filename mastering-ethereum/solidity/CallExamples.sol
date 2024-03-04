// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity 0.8.24;

contract calledContract {
    event callEvent(address sender, address origin, address from);
    
    function calledFunction() public {
        emit callEvent(msg.sender, tx.origin, address(this));
    }
}

library calledLibrary {
    event callEvent(address sender, address origin, address from);

    function calledFunction() public {
        emit callEvent(msg.sender, tx.origin, address(this));
    }
}

contract caller {
    function make_calls(calledContract _calledContract) public {
        // Calling calledContract and calledLibrary directly
        _calledContract.calledFunction(); // -> sender = caller.address, origin = msg.sender (who calls the make_calls func), from = calledContract address
        // result: 0x09cD59E96ab091d78634ee4EF12D30eedf3A44a0, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0x9841646172125FC9df32421010931d3737b7757d - correct!
        calledLibrary.calledFunction(); // -> sender = msg.sender, origin = msg.sender, from = caller.address
        // result: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0x09cD59E96ab091d78634ee4EF12D30eedf3A44a0 - correct!

        // Low-level calls using the address object for calledContract
        (bool successCall, ) = address(_calledContract).call(abi.encodeWithSignature("calledFunction()")); // -> sender = caller.address, origin = msg.sender, from = caller.address
        // result: 0x09cD59E96ab091d78634ee4EF12D30eedf3A44a0, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0x9841646172125FC9df32421010931d3737b7757d - incorrect: from = calledContract.address
        require(successCall, "call failed");

        (bool successDelegateCall, ) = address(_calledContract).delegatecall(abi.encodeWithSignature("calledFunction()")); // -> sender = msg.sender, origin = msg.sender, from = caller.address
        // resutl: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0x09cD59E96ab091d78634ee4EF12D30eedf3A44a0 - correct!
        require(successDelegateCall, "delegateCall failed");
    }
}