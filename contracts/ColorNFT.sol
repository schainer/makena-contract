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
    uint256 private _mintPrice;
    uint256 private _mintCount;
    mapping(uint256 => uint256) private _tokenColor;


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
        _mintCount = 1;
    }

    function mint(uint256 _color) public payable whenNotPaused {
        require(msg.value == _mintPrice, 'Payment Rejected');
        require(_color <= 16777216, 'Bad Request');
        _tokenColor[_mintCount] = _color;
        _mint(msg.sender, _mintCount);
        _mintCount++;
    }

    function tokenColor(uint256 _id) public view returns (uint256) {
        require(_tokenColor[_id] > 0, 'Bad Request');
        return _tokenColor[_id];
    }

    function mintCount() public view returns (uint256) {
        return _mintCount;
    }

    function setMintPrice(uint256 _price) public onlyOwner {
        _mintPrice = _price;
    }

    function collectPayment(uint256 _amount) public onlyOwner {
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
