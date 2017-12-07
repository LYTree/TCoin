
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

