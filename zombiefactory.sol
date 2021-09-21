pragma solidity >=0.5.0 <0.6.0;

/*
This code is a part of cyptozombies.io course
https://cryptozombies.io

zombiefactory.sol makes new zombies


*/
///////////////////////////////////////////////////////////////////////////////////////
import "./ownable.sol";
import "./safemath.sol";




contract ZombieFactory is Ownable{

    
    using SafeMath for uint256;
    //  a zombie has an id , name , and dna
    event NewZombie(uint zombieId, string name, uint dna);

    //dna cannot be more than 16 digits

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime; 
        uint16 winCount;
        uint16 lossCount;
        
    }

    Zombie[] public zombies;
    
    // (key => value)
    mapping (uint => address) public zombieToOwner; //{uint , address}
    mapping (address => uint) ownerZombieCount;  // {address, uint}

    
    function _createZombie(string memory _name, uint _dna) internal {
        //gets zombie id 
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime),0,0)) - 1;
        //msg.sender is the address of the person calling the contract
        //links the id of the zombie to the address of person calling the contract
        zombieToOwner[id] = msg.sender;
        //increases the uint count of zombies for the msg.sender address
        ownerZombieCount[msg.sender]++;
        //When event is emitted, it stores the arguments passed in transaction logs
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
/* solidity tips

storage 
    refers to variables permanently on the blockchain
    memory variables are temporary, and are erased 
    between external function calls to your contract

 And as with function parameters, 
 it's convention to start private function 
 names with an underscore (_).

 view 
    function, meaning it's only viewing 
    the data but not modifying it:

 pure
    Solidity also contains pure functions, 
    which means you're not even accessing 
    any data in the app. 

 Event
    Events are a way for your contract to communicate 
    that something happened on the blockchain 
    to your app front-end,

 emit
    When event is emitted, it stores the arguments
    passed in transaction logs

 now 

    The variable now will return the current unix timestamp of the latest block

    Time units

    Solidity provides some native units for dealing with time.
    Solidity also contains the time units seconds, minutes, hours, days, weeks and years. 
    These will convert to a uint of the number of seconds in that length of time. 
    So 1 minutes is 60, 1 hours is 3600 (60 seconds x 60 minutes), 1 days is 86400 
    (24 hours x 60 minutes x 60 seconds), etc.
*/
