// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyFinalsActivity2 {
    address payable public owner;
    uint256 public creationTime;
    uint256 public INITIAL_ETH_AMOUNT = 2 ether;
    uint256 public remainingEth;

    event EtherReceived(address indexed from, uint256 amount);
    event EtherSent(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function receiveAndEmit() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    constructor() {
        owner = payable(msg.sender);
        creationTime = block.timestamp;
        remainingEth = INITIAL_ETH_AMOUNT;
    }

    receive() external payable {
        emit EtherReceived(msg.sender, msg.value);
        remainingEth += msg.value;
    }

    function sendEther(address payable _to, uint256 _amount) external onlyOwner {
        require(_to != address(0), "Invalid address");
        require(_amount <= remainingEth, "Insufficient balance in contract");
        
        _to.transfer(_amount);
        emit EtherSent(_to, _amount);
        remainingEth -= _amount;
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
