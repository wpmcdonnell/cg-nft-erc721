/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


/** @dev Imports the OpenZeppelin implemtations of ERC721, Enumerable extension for 
  * inherited functions like totalSuppy(), Counters to automically generate the next token id after every mint, 
  * and ownable
  * for the onlyOwner modifer
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
  uint256 public maxSupply = 200;
  string public baseExtension = ".json";
  string baseURI = 'https://gateway.pinata.cloud/ipfs/QmTd3uKQp42cQ4dt2ztJNJVgJSnjQ36iYzKzwhuj9S1vD2/';

    constructor() ERC721("CG NFTs", "CG-NFT") {
    }

    /** @dev Sets the base URI for the generated Token URI
      * @param _newBaseURI URL of IPFS folder gateway of JSON Files
      */
    function setBaseURI(string memory _newBaseURI) external onlyOwner {
    baseURI = _newBaseURI;
  }

    /** @dev internal function used by TokenURI to return the baseURI.
      * @return baseURI the base URI
      */
    function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }


    /** @dev Allows owner to mint a single nft to their own wallet,
      * requires the supply to be greater than or equal to 200,
      * _safemint() is used to mint to msg.sender which is owner, and the current tokenID
      * @return currentTokenId The token ID
      */
    function mint() external onlyOwner returns(uint256) {
      require(maxSupply >= tokenIds.current(), "All tokens has been minted!");
      tokenIds.increment();
      uint256 currentTokenId = tokenIds.current();
      _safeMint(msg.sender, currentTokenId);
      return currentTokenId;
    }

    /** @dev Allows a function call to view the metadata aka the tokenURI
      * of a specfic tokenID that has already been minited
      * @param tokenId the token id of a specfic already minted NFT
      * requires the supply to be greater than or equal to 20,
      * _safemint() is used to mint to msg.sender which is owner, and the current tokenID
      * @return tokenURI which equals the base extension + the tokenid + the baseExtension 
      * the base extenstion in this case is ".json"
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
