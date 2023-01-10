//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface CryptLike {
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function balanceOf(address) external view returns (uint balance);
}

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
        owner = msg.sender;
        crypt = CryptLike(crypt_);
    }

    function binarySearch(uint256[] memory array, uint256 element) internal pure returns (bool) {
        if (array.length == 0) {
            return false;
        }

        uint256 low = 0;
        uint256 high = array.length;

        while (low <= high) {
            uint256 mid = (low & high) + (low ^ high) / 2;

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

    function setGameBalance() public {
        require(msg.sender==owner, "NO");
        bank[address(this)] = crypt.balanceOf(address(this));
    }

    function signup() public {
        if (bank[msg.sender] != 0 && players[msg.sender]==false) {
            players[msg.sender] = true; 
        }
        if (players[msg.sender]) return;
        require( bank[address(this)] > 1000*(10**18), "Empty Treasury");
        bank[address(this)] -= 1000 * (10**18);
        bank[msg.sender] +=  1000 * (10 ** 18);
        players[msg.sender] = true;
    }

    function deposit(uint amount) public {
        require(crypt.balanceOf(msg.sender) >= amount * (10**18), "No tokens");
        crypt.transferFrom(msg.sender, address(this), amount * (10**18));
        bank[msg.sender] += amount * (10**18);
    }

    function withdraw() public {
        crypt.transfer(msg.sender, bank[msg.sender]);
        bank[msg.sender] = 0;
    }

    function purchase() public {
        require(players[msg.sender] == true, "Signup");
        require( bank[msg.sender] > (150 * (10**18)), "Funds" );
        bank[msg.sender] -= (150 * (10**18));
        bank[address(this)] += (150 * (10**18));
        eggCount = eggCount+1;
        bytes memory newEgg = new bytes(3);
        eggs[eggCount] = newEgg;
        eggOriginTime[eggCount] = block.timestamp;
        owned[msg.sender].push(eggCount);
    }

    function getOwnedEggs(address _address) external view returns (uint[] memory) {
        uint length = owned[_address].length;
        uint[] memory data = new uint[](length);
        for (uint i = 0; i<length; i++) {
            data[i] = owned[_address][i];
        }
        return data;
    }

    function setEggElement(string memory element, uint egg) public {
        require( bank[msg.sender] >= 50*(10**18), "Need 50 tokens");
        bool index = binarySearch(owned[msg.sender], egg);
        require(index, "Egg 404");
        require(block.timestamp >= eggOriginTime[egg] + 2 days, "2 days");

        bytes memory eggBytes = eggs[egg];
        require(eggBytes[0] == '', "SET");

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
        require( bank[msg.sender] >= 75*(10**18), "Need 75 tokens");
        bool index = binarySearch(owned[msg.sender], egg);
        require(index, "Egg not found");
        require(block.timestamp >= eggOriginTime[egg] + 4 days, "4 days");


        bytes memory eggBytes = eggs[egg];
        require(eggBytes[1] == '', "SET");


        bank[msg.sender] -= 75*(10**18);
        bank[address(this)] += 75*(10**18);
        if ( keccak256(abi.encodePacked(persona)) == keccak256(abi.encodePacked("Honesty")) ) {
            eggBytes[1] = '1';
        } else if ( keccak256(abi.encodePacked(persona)) == keccak256(abi.encodePacked("Cunning")) ) {
            eggBytes[1] = '2';
        } else if ( keccak256(abi.encodePacked(persona)) == keccak256(abi.encodePacked("Hardworking")) ) {
            eggBytes[1] = '3';
        } else if ( keccak256(abi.encodePacked(persona)) == keccak256(abi.encodePacked("Inspiring")) ) {
            eggBytes[1] = '4';
        }

        eggs[egg] = eggBytes;
    }

    function setEggTrait(string memory trait, uint egg) public {
        require( bank[msg.sender] >= 75*(10**18), "Need 75 tokens");
        bool index = binarySearch(owned[msg.sender], egg);
        require(index, "Egg 404");
        require(block.timestamp >= eggOriginTime[egg] + 6 days, "6 days");


        bytes memory eggBytes = eggs[egg];
        require(eggBytes[2] == '', "SET");
        

        bank[msg.sender] -= 75*(10**18);
        bank[address(this)] += 75*(10**18);
        if ( keccak256(abi.encodePacked(trait)) == keccak256(abi.encodePacked("Bravery")) ) {
            eggBytes[2] = '1';
        } else if ( keccak256(abi.encodePacked(trait)) == keccak256(abi.encodePacked("Ambition")) ) {
            eggBytes[2] = '2';
        } else if ( keccak256(abi.encodePacked(trait)) == keccak256(abi.encodePacked("Empathy")) ) {
            eggBytes[2] = '3';
        }

        eggs[egg] = eggBytes;
    }
}