/*
    This is a ERC721 implentation for the ownership of zombies
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";

// when implementing a token contract have to import it
import "./erc721.sol";

// Declare ERC721 inheritance here
contract ZombieOwnership is ZombieAttack , ERC721{
  function balanceOf(address _owner) external view returns (uint256) {
    // This function simply takes an address, and returns how many tokens that address owns.
    // In our case, our "tokens" are Zombies
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    // This function takes a token ID (in our case, a Zombie ID), 
    // and returns the address of the person who owns it.
    return zombieToOwner[_tokenId];
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {

  }

  function approve(address _approved, uint256 _tokenId) external payable {

  }
}

/*
Solidity tips


    A token on Ethereum is basically just a smart contract that follows some common rules — 
    namely it implements a standard set of functions that all other token contracts share,
    such as 
    transferFrom(address _from, address _to, uint256 _tokenId) 
    and 
    balanceOf(address _owner)

    Internally the smart contract usually has a mapping, mapping(address => uint256) balances,
    that keeps track of how much balance each address has.

    ERC20 token basically good for currencies -divisible etc


    ERC20 tokens share the same set of functions with the same names
    This means if you build an application that is capable of interacting with one ERC20 token,
    it's also capable of interacting with any ERC20 token.

    ERC721 tokens good fit for cryptozombies not interchangeable each one is assumed to be unique, and are not divisible. 
    You can only trade them in whole units, and each one has a unique ID.  


*/

/*
ERC721 standard:
    contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  function balanceOf(address _owner) external view returns (uint256);
  function ownerOf(uint256 _tokenId) external view returns (address);
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
  function approve(address _approved, uint256 _tokenId) external payable;
  }
*/