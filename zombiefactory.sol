pragma solidity >=0.5.0 <0.6.0;

/*
This code is a part of cyptozombies.io course
https://cryptozombies.io

zombiefactory.sol makes new zombies

storage refers to variables permanently on the blockchain
memory variables are temporary, and are erased between external function calls to your contract
*/
contract ZombieFactory {

    //  a zombie has an id , name , and dna

    event NewZombie(uint zombieId, string name, uint dna);

    //dna cannot be more than 16 digits

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;
    
    // (key => value)
    mapping (uint => address) public zombieToOwner; //{uint , address}
    mapping (address => uint) ownerZombieCount;  // {address, uint}

    
    function _createZombie(string memory _name, uint _dna) private {
        //gets zombie id 
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        //msg.sender is the address of the person calling the contract
        //links the id of the zombie to the address of person calling the contract
        zombieToOwner[id] = msg.sender;
        //increases the uint count of zombies for the msg.sender address
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
