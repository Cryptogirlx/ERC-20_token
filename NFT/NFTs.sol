pragma solidity 0.7.4;

contract CryptoCats {
    // an NTF is essentially a struct that is being put into an array and the uniqe udentifier is the index from the array

    string public constant name = "myKitty";
    string public constant symbol = "MKT";

    event Transfer(address from, address _to, uint256 catID);

    event Birth(
        address owner,
        uint256 catID,
        uint256 momID,
        uint256 dadID,
        uint256 genes
    );

    struct Cat {
        uint256 gene;
        uint256 birthDay;
        uint256 momID;
        uint256 dadID;
        uint256 generation;
    }

    Cat[] cats;

    mapping(uint256 => address) owner;
    mapping(address => uint256) howManyCats;

    function balanceOf(address owner)
        public
        view
        returns (uint256 numberOfCats)
    {
        return howManyCats[owner];
    }

    function totalSupply() public view returns (uint256 allCats) {
        return cats.length;
    }

    function ownerOf(uint256 catID) public view returns (address catOwner) {
        return owner[catID];
    }

    function transfer(address _to, uint256 _catID)
        external
        returns (bool success)
    {
        require(_to != address(0));
        require(_to != address(this));
        require(_owns(msg.sender, _catID));

        _transfer(msg.sender, _to, _catID);

        return true;
    }

    function getAllCatsForAddress(address _owner)
        external
        view
        returns (uint256[] memory allCatsOwned)
    {
        uint256[] memory allCatsOwned = new uint256[](howManyCats[_owner]);

        uint256 counter = 0;

        for (uint256 i = 0; i < cats.length; i++) {
            if (howManyCats[i] == _owner) {
                allCatsOwned[counter] = i;
                counter++;
            }
            return allCatsOwned;
        }

        return allCatsOwned;
    }

    function createCatGenZero(uint256 _genes)
        public
        view
        returns (uint256 generation)
    {
        _createCat(0, 0, 0, 0, _genes, msg.sender);

        return generation;
    }

    function _createCat(
        uint256 _gene,
        uint256 _birthDay,
        uint256 _momID,
        uint256 _dadID,
        uint256 _generation,
        address _owner
    ) private returns (uint256 newCatID) {
        Cat memory newCat =
            Cat({
                gene: _gene,
                birthDay: block.timestamp,
                momID: _momID,
                dadID: _dadID,
                generation: _generation,
                owner: _owner
            });

        cats.push(newCat);

        uint256 _newCatID = cats.length - 1;

        emit Birth(_owner, newCatID, _momID, _dadID, _gene);

        _transfer(address(0), _owner, newCatID);

        return newCatID;
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _catID
    ) internal returns (bool success) {
        owner[_to]++;
        howManyCats[_catID] = _to;

        if (_from != address(0)) {
            howManyCats[_from]--;
        }
        emit Transfer(_from, _to, _catID);

        return true;
    }

    function _owns(address _buyer, uint256 _catID)
        internal
        view
        returns (bool success)
    {
        howManyCats[_catID] == _buyer;

        return true;
    }
}
