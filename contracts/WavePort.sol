pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal{
    uint256 totalWaves;
    uint256 private seed;
    event NewWave(address indexed from, uint256 timestamp, string message);
    mapping(
        address => uint256
    ) counter;

    mapping(address => uint256) public lastWavedAt;

    struct Wave{
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;
    constructor() payable{
        console.log("HEHE! I'm a smart contract.");
        seed = (block.timestamp + block.difficulty)%100000;
    }

    function wave(string memory _message) public{
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "wait 15 mint!"
        );

        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves++;
        counter[msg.sender]++;
        console.log("%s waved at you w/ message %s", msg.sender, _message);
        waves.push(Wave(msg.sender, _message, block.timestamp));

        console.log("Random # generated :%d", seed);

        if(seed<=50){
            console.log("%s won", msg.sender);
            uint256 prizeAmt = 0.0001 ether;

            require(
                prizeAmt <= address(this).balance, 
                "Trying to widthraw more money then in contract."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmt}("");
            require(success, "Failed to withdraw money from contract.");
        }
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns(Wave[] memory){
        return waves;
    }

    function getTotalWaves() public view returns (uint256){
        console.log("we have %d total waves!", totalWaves);
        return totalWaves;
    }
}