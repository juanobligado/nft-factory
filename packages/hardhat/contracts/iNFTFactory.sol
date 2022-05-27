pragma solidity ^0.8.9;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import "./iNFT.sol";

contract iNFTFactory is  ERC2771Context, Ownable {
  
  event iNFTCreated(address indexed userAddress,address indexed contractAddress );

  mapping(address => address) private  userContracts;
  
  constructor(address trustedForwarder)   ERC2771Context(trustedForwarder) {

  }

  function mintItem(address to, string memory tokenURI)
      public
      onlyOwner
      returns (uint256) {

      address  userContractAddress = userContracts[to];
      if(userContractAddress == address(0)){        
        // Attempt to create new iNFT contract for the user
        userContractAddress = address(new iNFT(owner()));        
        require(userContractAddress != address(0));
        userContracts[to] = userContractAddress;
        emit iNFTCreated(to,userContractAddress);
        
      }
      return iNFT(userContractAddress).mintItem(to, tokenURI);
  }

  function _msgSender() internal view override(Context, ERC2771Context) returns (address) {
    return ERC2771Context._msgSender();
  }
  
  function _msgData() internal view override(Context, ERC2771Context) returns (bytes calldata) {
    return ERC2771Context._msgData();
  }
}