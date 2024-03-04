pragma solidity ^0.4.8;

contract EtherStoreV2 {
    uint256 public constant withdrawalLimit = 1 ether;
    // initialize the mutex
    bool reEntrancyMutex = false;

    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        // limit the withdrawal to avoid reentrancy using the reEntrancyMutex
        require(!reEntrancyMutex);
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        // set the reEntrancy mutex before the external call
        reEntrancyMutex = true;
        
        // using transfer instead of call because it only sends 2300 gas whic is insufficient
        // for the destination address/contract to call another contract, i.e., to call again
        msg.sender.transfer(_weiToWithdraw);
        
        // release the mutex after the external call
        reEntrancyMutex = false;
    }
}
