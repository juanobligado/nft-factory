//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";


contract iNFT is ERC2771Context , ERC721, Ownable  {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  mapping (uint256 => string) private _tokenURIs;
  
  constructor(address trustedForwarder) ERC2771Context(trustedForwarder) ERC721("iNFTCreator", "iNFT")  {
  }

  function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
  }

  function _baseURI()  internal  pure override   returns (string memory) {
        return "https://ipfs.io/ipfs/";
  }

  function mintItem(address to, string memory tokenURI)
      public
      onlyOwner
      returns (uint256)
  {
      _tokenIds.increment();

      uint256 id = _tokenIds.current();
      _mint(to, id);
      _setTokenURI(id, tokenURI);

      return id;
  }

  // Use Meta Transaction Sender and Msg
  function _msgSender() internal view override(Context, ERC2771Context) returns (address) {
    return ERC2771Context._msgSender();
  }

  function _msgData() internal view override(Context, ERC2771Context) returns (bytes calldata) {
    return ERC2771Context._msgData();
  }

  
}