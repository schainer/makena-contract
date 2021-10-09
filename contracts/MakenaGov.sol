pragma solidity ^0.5.6;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Roles.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "./Strings.sol";
import "./MakenaNFT.sol";


contract MakenaGov is Ownable {
    using Strings for string;
    using SafeMath for uint256;

    struct Draw {
        uint256 blockNumber;
        uint256 diceNumber;
    }

    event Roll(uint256 key);
    event CheckDice(uint256 dice, uint256 blockNum, bytes32 hash);

    mapping(uint256 => Draw) diceNumbers;
    uint256 diceKey = 0;

    function roll() public onlyOwner returns (uint256) {
        diceKey += 1;
        diceNumbers[diceKey].blockNumber = block.number + 1;
        emit Roll(diceKey);
        return diceKey;
    }

    function checkDice(uint256 key) public onlyOwner returns (uint256 dice, uint256 blockNum, bytes32 hash) {
        require(key > 0 && diceNumbers[key].blockNumber > 0);
        if (diceNumbers[key].diceNumber == 0) {
            bytes32 _blockHash = blockhash(diceNumbers[key].blockNumber);
            uint256 _diceNum = uint(_blockHash) % 6 + 1;
            diceNumbers[key].diceNumber = _diceNum;
        }
        emit CheckDice(diceNumbers[key].diceNumber, diceNumbers[key].blockNumber, blockhash(diceNumbers[key].blockNumber));
        dice = diceNumbers[key].diceNumber;
        blockNum = diceNumbers[key].blockNumber;
        hash = blockhash(diceNumbers[key].blockNumber);
    }
}
