pragma solidity ^0.4.18;

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

