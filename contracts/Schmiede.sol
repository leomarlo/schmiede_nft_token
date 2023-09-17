// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Schmiede is ERC721URIStorage {

    address public owner;
    address internal _pendingOwner;
    string public baseURI;
    uint256 private _tokenIdCounter;

    bool public ownerMintControlRevoked;

    mapping(address=>bool) public whitelisted;

    // Mapping from token ID to content identifier (CID)
    mapping(uint256 => string) private _tokenCIDs;

    constructor() ERC721("There Will Be Blood", "BLOOD") {
        owner = msg.sender;
        whitelisted[owner] = true;
    }

    function setBaseURI(string memory _baseURI) external {
        require(msg.sender == owner, "Only the owner can set the base URI");
        baseURI = _baseURI;
    }

    function whitelistSomeone(address newMember) external {
        require(whitelisted[msg.sender], "Only whitelisted can whitelist");
        whitelisted[newMember] = true;
    }

    function unwhitelistSomeone(address newMember) external {
        require(msg.sender==owner, "Only owner can unwhitelist someone");
        whitelisted[newMember] = false;
    }

    function changeOwner(address newOwner) external {
        require(msg.sender==owner, "Only owner can assign new Owner");
        _pendingOwner = newOwner;
    }

    function claimOwnership() external {
        require(msg.sender==_pendingOwner, "Only pending owner can claim ownership");
        owner = _pendingOwner;
    }


    function mint(string memory contentIdentifier) external {
        require(_allowedToMint(), "Not allowed to mint");
        require(bytes(contentIdentifier).length > 0, "Content Identifier is required");

        _tokenIdCounter += 1;
        uint256 newTokenId = _tokenIdCounter;

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, string(abi.encodePacked(baseURI, contentIdentifier)));
        _tokenCIDs[newTokenId] = contentIdentifier;
    }

    function getTokenCID(uint256 tokenId) external view returns (string memory) {
        return _tokenCIDs[tokenId];
    }

    function mintControl(bool revoke) external {
        require(msg.sender == owner, "Only the owner can set the base URI");
        ownerMintControlRevoked = revoke;
    }

    function _allowedToMint() view internal returns(bool){
        return ownerMintControlRevoked ? whitelisted[msg.sender] : msg.sender == owner;
    }
}
