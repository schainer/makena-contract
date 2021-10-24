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
    uint256 mintPrice;
    mapping(uint256 => bool) uniqueColor;


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

    function mint(uint256 _color) public payable whenNotPaused {
        require(msg.value == mintPrice, 'Payment Rejected');
        require(!uniqueColor[_color], 'Color Exist');
        _mint(msg.sender, _color);

    }

    function setMintPrice(uint256 _price) public onlyOwner {
        mintPrice = _price;
    }

    function collect(uint256 _amount) public onlyOwner {
        require(address(this).balance >= _amount, 'Not Enough Balance');
        msg.sender.transfer(_amount);
    }

//    function transferOwnership(address newOwner) public onlyOwner {
//        // also renounce admin
//        // also renounce pauser
//        super.transferOwnership(newOwner);
//    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        // Whitelist OpenSea proxy contract for easy trading.
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        if (address(proxyRegistry.proxies(owner)) == operator) {
            return true;
        }
        return super.isApprovedForAll(owner, operator);
    }


}
