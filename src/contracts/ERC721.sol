// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";

/*
    Building the minting function:
        a-nft to point to an address
        b-keep track of tokens id
        c-keep track of token owner addresses to tokens id
        d-keep track of how many tokens an owner address has
        e-create an event that emits a transfer log - contract addres where 
         it is being minted to, the id
*/

contract ERC721 is ERC165, IERC721 {
    // mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;
    // mapping from owner to number of tokens owned
    mapping(address => uint256) private _ownedTokensCount;
    // mapping from tokenId to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("transferFrom(bytes4)")
            )
        );
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "owner query for non-existing token");
        return _ownedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "owner query for non-existing token");
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        //setting the address of nft owner  to check the mapping
        // of the address from tokenowner at the tokenId
        address owner = _tokenOwner[tokenId];
        // return thruthiness the address is not zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        // requires that the address is not zero
        require(to != address(0), "ERC721: minting to the zero address.");
        // requires that the token does not already exists
        require(!_exists(tokenId), "ERC721: token already minted.");
        // we are adding a new addres with the token ID for minting
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting and add to the count
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(
            _to != address(0),
            "Error - ERC721 Transfer to the zero address"
        );
        require(
            ownerOf(_tokenId) == _from,
            "Trying to transfer a token the address does not is owner"
        );
        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_to != owner, "Error - approval to the current owner");
        require(
            msg.sender == owner,
            "Current caller is not the owner of the token"
        );
        _tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }

    function getApproved(uint256 tokenId)
        public
        view
        virtual
        returns (address)
    {
        require(
            _exists(tokenId),
            "ERC721: approved query for nonexistent token"
        );
        return _tokenApprovals[tokenId];
    }

    function isApprovedOrOwner(address _spender, uint256 _tokenId)
        internal
        view
        returns (bool)
    {
        require(_exists(_tokenId), "Token does not exist");
        address owner = ownerOf(_tokenId);
        return (_spender == owner || getApproved(_tokenId) == _spender);
    }
}
