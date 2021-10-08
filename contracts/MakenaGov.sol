pragma solidity ^0.4.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Roles.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./Strings.sol";
import "./MakenaNFT.sol";


contract MakenaGov is Ownable {
    using Strings for string;
    using SafeMath for uint256;

    mapping(uint256 => uint256) diceNumbers

    function roll() public onlyOwner returns(uint256) {

    }

    function checkDice() public onlyOwner returns(uint256) {

    }
}
