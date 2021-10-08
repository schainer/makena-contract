pragma solidity ^0.5.6;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Roles.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./Strings.sol";


contract MakenaNFT is ERC721Full, Ownable {
    using Strings for string;
    using SafeMath for uint256;

    mapping(uint256 => bool) _uniqueId;

    constructor(string memory _tokenName, string memory _symbol) ERC721Full(_tokenName, _symbol) {}

    function mint(uint256 _id, address _recipient) public onlyOwner {
        require(!_uniqueId[_id], "Invalid Token ID");
        _uniqueId[_id] = true;
        _mint(_recipient, _id);
    }

}
