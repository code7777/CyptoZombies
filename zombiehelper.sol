pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether;
    /*
        make sure the zombies level is above or equal to required amount
    */
    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _; //merge wildcard - put at the end of function modifiers
    }

    function withdraw() external onlyOwner {
        address payable _owner = address(uint160(owner()));
        _owner.transfer(address(this).balance);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
    }
    /*
        For zombies level 2 and higher, users will be able to change their name.
        For zombies level 20 and higher, users will be able to give them custom DNA.
    */
    
    function changeName(uint256 _zombieId, string calldata _newName)
        external
        aboveLevel(2, _zombieId)
    {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
    {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }

    /* 
     @dev view a users entire zombie army 
     view function becaus it only reads data from blockchain
    */
    function getZombiesByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < zombies.length; i++) {
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
    /////////////////////////////////////////////////
    
    visibility modifiers
        where the function can be called from
        private
            only callable from other functions inside the contract
        internal
            like private but can also be called by contracts that inherit from this one
        external
            can only be called outside the contract
        public
            can be called anywhere

    state modifiers
        how the function interacts with the BlockChain
        view
            by running the function, no data will be saved/changedd
        pure
            not only does the function not save any data to the blockchain,
            but it also doesn't read any data from the blockchain
        Both of these don't cost any gas to call if they're called externally 
        from outside the contract (but they do cost gas if called 
        internally by another function)

    payable modifier
        special type of function that can receive Ether
    
*/
