// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Staker {

  // Balances of the user's stacked funds
  mapping(address => uint256) public balances;

  // Contract's Events
  event Stake(address indexed sender, uint256 amount);

  // create a token. Different contract?

  // TODO use a custom token
  function stake() public payable {
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }

  // return a staked version of token 

  // let holders of staked token claim a single NFT

  // NFT has some dynamic properties

  // display total staked

  // allow user to withdraw
   function withdraw() public {
    uint256 userBalance = balances[msg.sender];

    // check if the user has balance to withdraw
    require(userBalance > 0, "You don't have balance to withdraw");

    // reset the balance of the user
    balances[msg.sender] = 0;

    // Transfer balance back to the user
    (bool sent,) = msg.sender.call{value: userBalance}("");
    require(sent, "Failed to send user balance back to the user");
  }

  
  
}
