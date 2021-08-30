pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";
////////////////////////////////////////////////////////////////////////////////////////
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

  KittyInterface kittyContract;
  //gets address of the CryptoKitties contract
  function setKittyContractAddress(address _address) external onlyOwner{
    kittyContract = KittyInterface(_address);
  }

  //cooldown time before feeding
  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  //ready to feed
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= now);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna , string memory _species) internal {


    //make sure person calling the contract is the owner of the zombie
    require(msg.sender == zombieToOwner[_zombieId]);

    //get zombies DNA 
    Zombie storage myZombie = zombies[_zombieId];
    //make sure zombie is ready to feed 
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;

    //if the species is declared to be a kitty the dna will have a 99 at the end
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    //feeding triggers CoolDown time
    _triggerCooldown(myZombie);
  }

   function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    // And modify function call here:
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
//////////////////////////////////////////////////////////////////////////////////////
/*Solidity tips

internal  
  is the same as private, 
  except that it's also accessible 
  to contracts that inherit from this contract.

external 
  external is similar to public, 
  except that these functions
  can ONLY be called outside the contract 
  — they can't be called by other functions inside that contract.

 For our contract to talk to another contract on the blockchain that we don't own, 
 first we need to define an interface.

 uint256 and uint are the same thing
//////////////////////////////////////////////////////////////////////////////////////////////////////
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
/////////////////////////////////////////////////////////////////////////////////////////

      In Lesson 1, we mentioned that there are other types of uints: uint8, uint16, uint32, etc.

      Normally there's no benefit to using these sub-types because Solidity 
      reserves 256 bits of storage regardless of the uint size. 
      For example, using uint8 instead of uint (uint256) won't save you any gas.

      But there's an exception to this: inside structs.

      If you have multiple uints inside a struct, 
      using a smaller-sized uint when possible will allow Solidity to pack 
      these variables together to take up less storage. 

      struct NormalStruct {
        uint a;
        uint b;
        uint c;
      }

      struct MiniMe {
        uint32 a;
        uint32 b;
        uint c;
      }

      // `mini` will cost less gas than `normal` because of struct packing
      NormalStruct normal = NormalStruct(10, 20, 30);
      MiniMe mini = MiniMe(10, 20, 30);

      For this reason, inside a struct you'll want to use the smallest 
      integer sub-types you can get away with.

      You'll also want to cluster identical data types together
       (i.e. put them next to each other in the struct) so that Solidity 
       can minimize the required storage space. For example, 
       a struct with fields uint c; uint32 a; uint32 b; will cost less gas than a struct with fields uint32 
      a; uint c; uint32 b; because the uint32 fields are clustered together.
*/