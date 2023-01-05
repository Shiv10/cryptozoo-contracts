//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

//promt: An illustration that is aesthetically pleasing with a glitchpop background showing an 
//animated character that has the following characteristics: aura - fire, persona - empathy, trait - intelligence

interface CryptLike {
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function balanceOf(address) external view returns (uint balance);
}

error CustomError(string message);

contract CryptoKiddies {
    mapping (address => uint) public bank;
    address public owner;
    mapping (address => bool) public players;
    mapping (uint => bytes) public eggs;
    mapping(uint => uint) public eggOriginTime;
    mapping (address => uint[]) public owned;
    uint256 eggCount = 0;
    CryptLike public crypt;

    constructor(address crypt_) {
        crypt = CryptLike(crypt_);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Need owner access to call function");
        _;
    }


    function binarySearch(uint256[] storage array, uint256 element) internal view returns (bool) {
        if (array.length == 0) {
            return false;
        }

        uint256 low = 0;
        uint256 high = array.length;

        while (low < high) {
            uint256 mid = Math.average(low, high);

            if (array[mid] > element) {
                high = mid-1;
            } else if (array[mid] < element) {
                low = mid + 1;
            } else {
                return true;
            }
        }

        return false;
    }

    function gameBalance() public view returns (uint) {
        return bank[address(this)]/(10**18);
    }

    function setGameBalance() public onlyOwner {
        bank[address(this)] = crypt.balanceOf(address(this));
    }

    function signup() public {
        if (bank[msg.sender] != 0 && players[msg.sender]==false) {
            players[msg.sender] = true; 
        }
        if (players[msg.sender]) return;
        require( bank[address(this)] > 1000*(10**18), "Not enough funds in treasury.");
        bank[address(this)] -= 1000 * (10**18);
        bank[msg.sender] +=  1000 * (10 ** 18);
        players[msg.sender] = true;
    }

    function getPlayerBalance() public view returns (uint) {
        uint playerBalance = bank[msg.sender] / (10**18);
        return playerBalance;
    }

    function deposit(uint amount) public {
        require(crypt.balanceOf(msg.sender) >= amount * (10**18), "Not enough crypt tokens in wallet");
        crypt.transferFrom(msg.sender, address(this), amount * (10**18));
        bank[msg.sender] += amount * (10**18);
    }

    function withdraw() public {
        crypt.transfer(msg.sender, bank[msg.sender]);
        bank[msg.sender] = 0;
    }

    function purchase() public {
        require(players[msg.sender] == true, "Need to signup before start playing");
        require( bank[msg.sender] > (150 * (10**18)), "Not enough CRP coins in bank" );
        bank[msg.sender] -= (150 * (10**18));
        bank[address(this)] += (150 * (10**18));
        eggCount = eggCount+1;
        bytes memory newEgg = new bytes(5);
        eggs[eggCount] = newEgg;
        eggOriginTime[eggCount] = block.timestamp;
        owned[msg.sender].push(eggCount);
    }

    function getOwnedEggs() public view returns (uint[] memory) {
        uint length = owned[msg.sender].length;
        uint[] memory data = new uint[](length);
        for (uint i = 0; i<length; i++) {
            data[i] = owned[msg.sender][i];
        }
        return data;
    }

    function setEggElement(string memory element, uint egg) public {
        require( bank[msg.sender] >= 50*(10**18), "Need at least 50 tokens in bank to add element to egg");
        require(eggOriginTime[egg] != 0, "Egg does not exist");
        require(block.timestamp >= eggOriginTime[egg] + 1 weeks, "Need to wait a week to set element");
        
        bool index = binarySearch(owned[msg.sender], egg);
        if (index) {
            revert CustomError("Egg not found");
        }

        bytes memory eggBytes = eggs[egg];
        if (eggBytes[0] == '1' || eggBytes[0] =='2' || eggBytes[0] =='3' || eggBytes[0] =='4') {
            revert CustomError("Element already set");
        }

        bank[msg.sender] -= 50*(10**18);
        bank[address(this)] += 50*(10**18);
        if ( keccak256(abi.encodePacked(element)) == keccak256(abi.encodePacked("Fire")) ) {
            eggBytes[0] = '1';
        } else if ( keccak256(abi.encodePacked(element)) == keccak256(abi.encodePacked("Water")) ) {
            eggBytes[0] = '2';
        } else if ( keccak256(abi.encodePacked(element)) == keccak256(abi.encodePacked("Earth")) ) {
            eggBytes[0] = '3';
        } else if ( keccak256(abi.encodePacked(element)) == keccak256(abi.encodePacked("Air")) ) {
            eggBytes[0] = '4';
        }
        eggs[egg] = eggBytes;
    }

    function setEggPersonality(string memory persona, uint egg) public {
        require( bank[msg.sender] >= 75*(10**18), "Need at least 50 tokens in bank to add element to egg");
        require(eggOriginTime[egg] != 0, "Egg does not exist");
        require(block.timestamp >= eggOriginTime[egg] + 3 days, "Need to wait 3 days to set persona");
        
        bool index = binarySearch(owned[msg.sender], egg);
        if (index) {
            revert CustomError("Egg not found");
        }

        bytes memory eggBytes = eggs[egg];
        if (eggBytes[2] == '1' || eggBytes[2] =='2' || eggBytes[2] =='3' || eggBytes[2] =='4') {
            revert CustomError("Persona already set");
        }

        bank[msg.sender] -= 75*(10**18);
        bank[address(this)] += 75*(10**18);
        if ( keccak256(abi.encodePacked(persona)) == keccak256(abi.encodePacked("Honesty")) ) {
            eggBytes[2] = '1';
        } else if ( keccak256(abi.encodePacked(persona)) == keccak256(abi.encodePacked("Cunning")) ) {
            eggBytes[2] = '2';
        } else if ( keccak256(abi.encodePacked(persona)) == keccak256(abi.encodePacked("Hardworking")) ) {
            eggBytes[2] = '3';
        } else if ( keccak256(abi.encodePacked(persona)) == keccak256(abi.encodePacked("Inspiring")) ) {
            eggBytes[2] = '4';
        }

        eggs[egg] = eggBytes;
    }

    function setEggTrait(string memory trait, uint egg) public {
        require( bank[msg.sender] >= 75*(10**18), "Need at least 50 tokens in bank to add element to egg");
        require(eggOriginTime[egg] != 0, "Egg does not exist");
        require(block.timestamp >= eggOriginTime[egg] + 2 weeks, "Need to wait 2 weeks to set trait");
        
        bool index = binarySearch(owned[msg.sender], egg);
        if (index) {
            revert CustomError("Egg not found");
        }

        bytes memory eggBytes = eggs[egg];
        if (eggBytes[1] == '1' || eggBytes[1] =='2' || eggBytes[1] =='3' || eggBytes[1] =='4') {
            revert CustomError("Trait already set");
        }

        bank[msg.sender] -= 75*(10**18);
        bank[address(this)] += 75*(10**18);
        if ( keccak256(abi.encodePacked(trait)) == keccak256(abi.encodePacked("Bravery")) ) {
            eggBytes[1] = '1';
        } else if ( keccak256(abi.encodePacked(trait)) == keccak256(abi.encodePacked("Ambition")) ) {
            eggBytes[1] = '2';
        } else if ( keccak256(abi.encodePacked(trait)) == keccak256(abi.encodePacked("Empathy")) ) {
            eggBytes[1] = '3';
        } else if ( keccak256(abi.encodePacked(trait)) == keccak256(abi.encodePacked("Intelligence")) ) {
            eggBytes[1] = '4';
        }

        eggs[egg] = eggBytes;
    }
}