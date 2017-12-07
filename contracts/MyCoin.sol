pragma solidity ^0.4.18;

import "./StandardToken.sol";
import "./Owned.sol";


contract MyCoin is StandardToken, Owned{
	string public constant nameToken = "MyCoin";
	string public constant symbolToken = "MYC";
	uint public constant decimalsToken = 8;
	
	function MyCoin(
		uint256 _initSupply) public {
		totalSupply = _initSupply * 10**uint256(decimalsToken);
		balances[msg.sender] = totalSupply;
	}	

	function mintCoin(address _target, uint256 _mintedAmount) public onlyOwner{

		require(balances[_target] + _mintedAmount > balances[_target]);
		
		balances[_target] = safeAdd(balances[_target], _mintedAmount); 
		totalSupply = safeAdd(totalSupply, _mintedAmount);
		Transfer(Owner, _target, _mintedAmount);
	}
}

