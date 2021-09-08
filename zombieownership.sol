/*
    This is a ERC721 implentation for the ownership of zombies
*/



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
 ERC721 tokens good fit for cryptozombies not interchangeable 
*/