# CyptoZombies
A zombie  video game, Ethereum DApp using Solidity


MMO crypto-collectible strategy game


![CryptoZombies1](https://user-images.githubusercontent.com/13813422/130870053-dafb8c69-d568-4035-b552-f2b7a326e24c.png)

This code is a part of cyptozombies.io course
https://cryptozombies.io


erc721.sol is a token contract which is for nondivisible tokens . The zombieOwnership is an ERC721

ownable.sol 
    contains certain properties for an owner of a contract

zombieattack.sol is when the zombieOwners battle each other. The wins and loses get recorded for the zombie owners

zombiefactory.sol makes new zombies 

zombiefeeding.sol  is a contract where the zombies feed on cryptoKitties using the cryptoKitty interface
https://www.cryptokitties.co/


zombiehelper.sol dictates when the zombies level up it is a child of the zombiefeeding class
    *users can change the zombies name above level 2

    *above level 20 the user can change the zombies DNA to a custom DNA

    *you can also view a users entire zombie army 

zombieownership.sol is an ERC721 Implementation of zombie ownership
    can transfer zombies, see blaance, etc


