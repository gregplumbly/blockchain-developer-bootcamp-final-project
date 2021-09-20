// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Staker {

  // Balances of the user's stacked funds
  mapping(address => uint256) public balances;

  // Contract's Events
  event Stake(address indexed sender, uint256 amount);

  function stake() public payable {
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }
  
}
