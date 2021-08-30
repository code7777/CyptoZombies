pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    /*
        make sure the zombies level is above or equal to required amount
    */
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;//merge wildcard - put at the end of function modifiers
    }
    /*
        For zombies level 2 and higher, users will be able to change their name.
        For zombies level 20 and higher, users will be able to give them custom DNA.
    */
    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }
    /* 
     @dev view a users entire zombie army 
     view function becaus it only reads data from blockchain
    */
    function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
        uint   length = ownerZombieCount[_owner];
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }



}
/*
    Solidity tips
    ///////////////////////////////////////////////////////////////////////////////
    you can optimize your DApp's gas usage for your users by using 
    read-only external view functions wherever possible.

    view
        functions don't cost any gas when they're called externally by a user

        marking a function with view tells web3.js that it only 
        needs to query your local Ethereum node to run the function

        If a view function is called internally from another function 
        in the same contract that is not a view function, it will still cost gas
    ///////////////////////////////////////////////////////////////////////////////
    
    a transaction on the blockchain would need to be run on every single node, and cost gas.

    Refrence types comprise structs, arrays and mappings. 
    If you use a reference type, you always have to 
    explicitly provide the data area where the type is stored:

        memory (whose lifetime is limited to a function call)

        storage (the location where the state variables are stored)

        calldata (special data location that contains the function arguments,
         only available for external function call parameters).
    /////////////////////////////////////////////////////////////////////////////////////////////
    memory arrays must be created with a length argument
    uint[] memory values = new uint[](3);

     (in this example, 3). 
     As of Solidity 0.5 they cannot be resized like storage arrays can with array.push(), 
     although this may  change in a future version of Solidity.
    One of the more expensive operations in Solidity is using storage — particularly writes
    
    TLDR :
    Save on gas , use read-only external view.
    Writing to storage is expensive, use memory inside functions if possible
*/