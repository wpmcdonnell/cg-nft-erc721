/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/** @dev Imports the OpenZeppelin library
  */
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/** @title CG 721
  */  
contract CG721 is ERC721Enumerable, Ownable {
  using Strings for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private tokenIds;
  uint256 public maxSupply = 20;
  string public baseExtension = ".json";
  string baseURI = 'https://gateway.pinata.cloud/ipfs/QmTf1YUgTBnYEKk9Zd5omHfGALi7gXpeugzcx8yTnYuS1j/';

    constructor() ERC721("CG NFTs", "CG-NFT") {
    }

    /** @dev Internal function used by TokenURI to return the baseURI
      */
    function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

    /** @dev Allows owner to mint a single nft to their own wallet
      */
    function mint() external onlyOwner returns(uint256) {
      require(maxSupply >= tokenIds.current(), "All tokens has been minted!");
      tokenIds.increment();
      uint256 currentTokenId = tokenIds.current();
      _safeMint(msg.sender, currentTokenId);
      return currentTokenId;
    }

    /** @dev Allows a function call to view the metadata aka the tokenURI
      */
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
