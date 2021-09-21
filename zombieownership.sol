/*
    This is a ERC721 implentation for the ownership of zombies
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";

// if someone who is not owner calls transferFrom with _tokenId we can use this mapping
//to quickly look up if he/she is approved to use that token 
mapping (uint => address) zombieApprovals;
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

  //transfters zombies from one owner to another
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
    ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from , _to , _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
      require(zomieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] ==msg.sender);
      _transfer(_from, _to , _tokenId);
  }

  // owner calls approve 
  // 1 give it the address of the new owner and tokenId you want him to take
  // 2 the new owner calls transferFrom with the _tokenId then the contract checks 
  //   to make sure then new owner has been approved

  //use zombieApprovals mapping as defined in this .sol contract to store who's been approved
  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId){
    zombieApprovals[_tokenId] = _approved;
    //emit Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    emit Approval(msg.sender, _approved , _tokenId);
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

    //called by sender
    // the token's owner calls transferFrom with his address as the _from parameter, 
    //the address he wants to transfer to as the _to parameter, and the _tokenId of the 
    //token he wants to transfer

    

  function approve(address _approved, uint256 _tokenId) external payable;

    //called by receiver
    //The  token's owner first calls approve with the address he wants to transfer to, 
    //and the _tokenID . The contract then stores who is approved to take a token, 

    //usually in a mapping (uint256 => address). 

    //Then, when the owner or the approved address calls transferFrom, 
    //the contract checks if that msg.sender is the owner or
    //is approved by the owner to take the token, and if so it transfers the token to him.

    //tldr call approve and give it the _approved address of the new owner, and the _tokenId you want 
    // them to take
  }
*/