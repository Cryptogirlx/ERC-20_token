pragma solidity 0.7.4;

contract DarkToken {
    address owner;

    // name of the token
    string internal tokenName;

    // symbol of the token
    string internal tokenSymbol;

    //set decimals
    uint256 decimal;

    // set total supply
    uint256 _totalSupply;

    //declare events
    event Transfer(address _from, address _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    //balance information map
    mapping(address => uint256) balance;

    //token allowance mapping
    mapping(address => mapping(address => uint256)) public allowed;

    constructor() {
        owner = msg.sender;
        tokenName = "Darkness";
        tokenSymbol = "DARK";
        decimal = 2;
    }

    function totalSupply() public view returns (uint256 _totalSupply) {
        _totalSupply = 1000;
        return _totalSupply;
    }

    function name() public view returns (string memory _name) {
        _name = tokenName;

        return _name;
    }

    function symbol() public view returns (string memory _symbol) {
        _symbol = tokenSymbol;

        return _symbol;
    }

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        _balance = balance[msg.sender];
    }

    function transfer(address payable _to, uint256 _value)
        public
        returns (bool success)
    {
        require(balance[msg.sender] >= _value);
        balance[msg.sender] -= _value;
        balance[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value)
        external
        returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256 remiaingBalance)
    {
        remiaingBalance = allowed[_owner][_spender];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success) {
        require(balance[msg.sender] >= _value);
        require(allowed[_from][msg.sender] >= _value);
        balance[_from] -= _value;
        balance[_to] += _value;
        allowed[_from][msg.sender] -= _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }
}
