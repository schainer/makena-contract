pragma solidity ^0.5.6;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Roles.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "./Strings.sol";

// Opensea Proxy Setup
contract OwnableDelegateProxy {}

contract ProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}

contract ColorNFT is ERC721Full, Ownable, Pausable {

    address proxyRegistryAddress;
    string contractUri;
    mapping(uint256 => bool)

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseUri,
        string memory _contractUri,
        address _proxyRegistryAddress
    ) ERC721(_name, _symbol) {
        proxyRegistryAddress = _proxyRegistryAddress;
        _setBaseURI(_baseURI);
        contractUri = _contractUri;
    }

    function mint() public payable whenNotPaused {

    }

    function setMintPrice() public onlyOwner {

    }

    function getBalance() public view onlyOwner {

    }

    function collect() public onlyOwner {

    }

    function transferOwnership(address newOwner) public onlyOwner {
        // also renounce admin
        super.transferOwnership(newOwner);
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        // Whitelist OpenSea proxy contract for easy trading.
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        if (address(proxyRegistry.proxies(owner)) == operator) {
            return true;
        }
        return super.isApprovedForAll(owner, operator);
    }


}
