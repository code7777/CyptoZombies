pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

//crytokiddies interface
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating, //1
    bool isReady, //2
    uint256 cooldownIndex, //3
    uint256 nextActionAt, //4
    uint256 siringWithId,//5
    uint256 birthTime, //6
    uint256 matronId, //7
    uint256 sireId, //8
    uint256 generation, //9
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {

    //address of the CryptoKitties contract
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // Initialize kittyContract here using `ckAddress`
    KittyInterface kittyContract = KittyInterface(ckAddress);

    //make sure person calling the contract is the owner of the zombie
    require(msg.sender == zombieToOwner[_zombieId]);

    //get zombies DNA 
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;

    //if the species is declared to be a kitty the dna will have a 99 at the end
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

   function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    // And modify function call here:
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
/*Solidity tips

internal is the same as private, 
except that it's also accessible 
to contracts that inherit from this contract. 
  

external is similar to public, 
except that these functions
 can ONLY be called outside the contract 
 — they can't be called by other functions inside that contract.

 For our contract to talk to another contract on the blockchain that we don't own, 
 first we need to define an interface.

 uint256 and uint are the same thing

 multiple returns example 

      function multipleReturns() internal returns(uint a, uint b, uint c) {
        return (1, 2, 3);
      }

      function processMultipleReturns() external {
        uint a;
        uint b;
        uint c;
        // This is how you do multiple assignment:
        (a, b, c) = multipleReturns();
      }

      // Or if we only cared about one of the values:
      function getLastReturnValue() external {
        uint c;
        // We can just leave the other fields blank:
        (,,c) = multipleReturns();
      }
*/