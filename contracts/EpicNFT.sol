// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyEpicNFT is ERC721URIStorage {
  
  // Keep track of how many minted. max supply? first 100? or over x?
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721 ("ConsenSysAcademyNFT", "STAK3R") {
  }

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  // Will have to call the token contract to check if a user is a staker
  function isStakeholder() public {}

  // Need to do all the IPFS stuff or make an SVG?
  function makeAnEpicNFT() public {
    require (_tokenIds.current() < 50);
    uint256 newItemId = _tokenIds.current();

    _safeMint(msg.sender, newItemId);
  
    // _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

  function mintedSoFar() public view returns (uint) {
      return _tokenIds.current();
  }




}
