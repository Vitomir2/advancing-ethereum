// SPDX-License-Identifier: CC-BY-SA-4.0
pragma solidity 0.8.24;

import "./Ownable.sol";

contract Mortal is Ownable {

    // Contract destructor
    // function destroy() public onlyOwner {
    //     selfdestruct(owner);    
    // }

    function checkOwner() public view onlyOwner returns (address) {
        return owner;
    }
}