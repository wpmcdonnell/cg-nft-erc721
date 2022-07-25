// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CG721 is ERC721Enumerable, Ownable {
  using Strings for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private tokenIds;
  uint256 public maxSupply = 20;
  string public baseExtension = ".json";
  string baseURI = '';

    constructor() ERC721("CG NFTs", "CG-NFT") {
    }

    // Only owner to set IPFS base
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

    // Internal to set base oppose to changing original OpenZeppelin ERC71.sol
    function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

    function mint() public returns(uint256) {
      require(maxSupply > tokenIds.current(), "All tokens has been minted!");

      // Need a send
      tokenIds.increment();
      uint256 currentTokenId = tokenIds.current();
      _safeMint(msg.sender, currentTokenId);
      return currentTokenId;
    }

    function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }
}
