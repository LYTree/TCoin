pragma solidity ^0.4.18;

/*
    Utilities & Common Modifiers
*/
contract Utils {
    /**
        constructor
    */
    function Utils() public {
    }

    // verifies that an amount is greater than zero
    modifier greaterThanZero(uint256 _amount) {
        require(_amount > 0);
        _;
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        require(_address != 0x0);
        _;
    }

    // verifies that the address is different than this contract address
    modifier notThis(address _address) {
        require(_address != address(this));
        _;
    }

    // Overflow protected math functions

    /**
        @dev returns the sum of _x and _y, asserts if the calculation overflows

        @param _x   value 1
        @param _y   value 2

        @return sum
    */
    function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
        uint256 z = _x + _y;
        assert(z >= _x);
        return z;
    }

    /**
        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number

        @param _x   minuend
        @param _y   subtrahend

        @return difference
    */
    function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
        assert(_x >= _y);
        return _x - _y;
    }

    /**
        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows

        @param _x   factor 1
        @param _y   factor 2

        @return product
    */
    function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
        uint256 z = _x * _y;
        assert(_x == 0 || z / _x == _y);
        return z;
    }
}

//Abstract contract for ERC20
pragma solidity ^0.4.18;

contract ERC20Token {
	
	uint256 public totalSupply;
	function balanceOf(address _owner) public constant returns (uint256 balance);
	function transfer(address _to, uint256 _value) public returns (bool success);
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
	function approve(address _spender, uint256 _value) public returns (bool success);
	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
	
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _from, address indexed _to, uint256 _value);
}

pragma solidity ^0.4.18;

contract Owned {
	address public Owner;
	address private newOwner;

	event OwnerUpdate(address _oldOwner, address _newOwner); 
	
	function Owned() public {
		Owner = msg.sender;
	}

	modifier onlyOwner {
		require(Owner == msg.sender);
		_;
	}
	
	function transferOwnership(address _newOwner) public onlyOwner {
		require(Owner != _newOwner);
		newOwner = _newOwner;
	}

	function acceptOwnership() public returns(bool success){
		require(msg.sender == newOwner);

		OwnerUpdate(Owner, msg.sender);	
		Owner = newOwner;
		newOwner = 0x0;
		return true;
	}
}

import "./ERC20Token.sol";
import "./Utils.sol";


contract StandardToken is ERC20Token, Utils {
	mapping (address => uint256) balances;
	mapping (address => mapping (address => uint256)) allowed;

	
	function _transfer(address _from, address _to, uint256 _value) internal {
		require(_from != 0x0);
		require(_to != 0x0);

		uint256 previousBalance = safeAdd(balances[_from], balances[_to]);
		balances[_from] = safeSub(balances[_from], _value);
		balances[_to] = safeAdd(balances[_to], _value);
		assert(previousBalance == safeAdd(balances[_from], balances[_to]));
		Transfer(_from, _to, _value);		
	}

    function transfer(address _to, uint256 _value) public returns (bool success){
		require(_to != 0x0);
		require(balances[msg.sender] >= _value);
		require(balances[_to] + _value > balances[_to]);

		_transfer(msg.sender, _to, _value);

		return true;
	}

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
		require(_to != 0x0);
		require(allowed[_from][msg.sender] >= _value);
		require(balances[_from] >= _value);

		allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);

		_transfer(_from, _to, _value);
		return true;	
	}

    function balanceOf(address _owner) public constant returns (uint256 balance){
		return balances[_owner];
	}

    function approve(address _spender, uint256 _value) public returns (bool success){
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
		return allowed[_owner][_spender];
	}	
}

