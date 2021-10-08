// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20 {
  using SafeMath for uint256;

  // Constructor - create token
  constructor(string memory name, string memory symbol) ERC20(name, symbol) {
      _mint(msg.sender, 100 * 10**uint(decimals()));
  }

  address[] internal stakeholders;

  // Balances of the user's staked funds
  mapping(address => uint256) internal stakes;

  // Contract's Events - Event for when a user stakes
  event Stake(address indexed sender, uint256 amount);

  // Burn the tokens so they cant be transferred?
  function stake() public payable {
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }

  // total staked.
  function totalStakes() public view returns(uint256) {
       uint256 _totalStakes = 0;
       for (uint256 s = 0; s < stakeholders.length; s += 1){
           _totalStakes = _totalStakes.add(stakes[stakeholders[s]]);
       }
       return _totalStakes;
  }

  // display number of stakers.
  function numberOfStakers() public view returns(uint256) {}

  // display an individual users total

  // allow user to withdraw
   function withdraw() public {
    uint256 userBalance = stakes[msg.sender];

    // check if the user has balance to withdraw
    require(userBalance > 0, "You don't have balance to withdraw");

    // reset the balance of the user
    stakes[msg.sender] = 0; // also need to remove from array 

    // Transfer balance back to the user
    (bool sent,) = msg.sender.call{value: userBalance}("");
    require(sent, "Failed to send user balance back to the user");
  }

  /* Let holders of staked token claim an NFT */

  // Check if they are a stakeholer
   function isStakeholder(address _address) public view returns(bool, uint256)
   {
       for (uint256 s = 0; s < stakeholders.length; s += 1){
           if (_address == stakeholders[s]) return (true, s);
       }
       return (false, 0);
   }

}

/* Stretch features
* Return a staked version of token.
* NFT has some dynamic properties. Not sure what. Maybe leave till later.
* Perhaps the staked token earns some rewards over time. A new NFT made available?
* Maybe add a lock mechanism. E.g one week. Display time left.
*/

  
  

