// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";

contract ManifestNFT is ERC721Connector {
    //array to store NFTs
    string[] public mnfstNFTs;
    mapping(string => bool) _mnfstNFTExists;

    function mint(string memory _mnfstNFT) public {
        require(!_mnfstNFTExists[_mnfstNFT], "Error: NFT already exist");
        mnfstNFTs.push(_mnfstNFT);
        uint256 _id = mnfstNFTs.length - 1;
        _mint(msg.sender, _id);
        _mnfstNFTExists[_mnfstNFT] = true;
    }

    constructor() ERC721Connector("manifestArt", "MNFSTART") {}
}
