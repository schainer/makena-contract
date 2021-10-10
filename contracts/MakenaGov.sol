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

    struct Horse {
        uint256 position;
        uint256 round;
    }

    struct Tile {
        string name;
        uint256 pieces;
        mapping(uint256 => uint256) tokens;
    }

    event Roll(uint256 key);
    event CheckDice(uint256 dice, uint256 blockNum, bytes32 hash);

    mapping(uint256 => Draw) diceNumbers;
    mapping(uint256 => Tile) gameBoard;
    uint256 tileCount = 0;
    uint256 diceKey = 0;



    function roll() public onlyOwner returns (uint256) {
        diceKey += 1;
        diceNumbers[diceKey].blockNumber = block.number + 1;
        emit Roll(diceKey);
        return diceKey;
    }

    function proceedHorse(uint256 key) public onlyOwner returns (uint256 dice, uint256 blockNum, bytes32 hash) {
        require(key > 0 && block.number > diceNumbers[key].blockNumber, 'Invalid Request');
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

    function addTile(string memory name, uint256 pieces) {
        uint256 _index = tileCount;
        tileCount += 1;
        Tile storage newTile = gameBoard[_index];
        newTile.name = name;
        newTile.pieces = pieces;
        gameBoard[_index] = newTile;
    }

    function splitTile(uint256 tileId, uint256 pieces) {
        Tile storage tile = gameBoard[tileId];
        require(tile.pieces < pieces, "Cannot be smaller");
        tile.pieces = pieces;
    }
}
