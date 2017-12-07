'use strict';
var MyCoin = artifacts.require('MyCoin');
let myc;

contract('MyCoin', function(accounts) {
	it("check initial parmeter", function(){
	return MyCoin.deployed().then(function(instance) { 
		var token = instance;
				
		var totalSupply;
		var account0;
		var nameToken;
		var symbolToken;
		var decimalsToken;	
		myc = instance;

		return token.totalSupply.call().then(function(misc){
			totalSupply = misc.toNumber();
			return token.balanceOf.call(accounts[0]); 
		}).then(function(misc){
			account0 = misc.toNumber();
			return token.nameToken.call();
		}).then(function(misc){
			nameToken = misc.toString();
			return token.symbolToken.call();
		}).then(function(misc){
			symbolToken = misc.toString();
			return token.decimalsToken.call();
		}).then(function(misc){
			decimalsToken = misc.toNumber();
			assert.equal(totalSupply, 100000000, "totalSupply");
			assert.equal(totalSupply, account0, "the first account");	
			assert.equal(nameToken, "MyCoin", "Token name");
			assert.equal(symbolToken, "MYC", "Token symbol");
			assert.equal(decimalsToken, 8, "Token decimal");
		});
	});
	});	

	it("check Owner", function(){
	return MyCoin.deployed().then(function(instance){
		var token = instance;
		var owner;
		return token.Owner.call().then(function(misc){
			owner = misc.toString();
			assert.equal(owner, accounts[0], "Owner");
			return token.transferOwnership(accounts[1], {from: accounts[0]});
		}).then(function(){
			return token.acceptOwnership({from:accounts[1]});
		}).then(function(misc){
			return token.Owner.call().then(function(misc){
			owner = misc.toString();
			assert.equal(owner, accounts[1], "Owner Update");
		});
		});
	});	
	});

	it("Check Transfer", function(){
	return MyCoin.deployed().then(function(instance){
		var token = instance;
		var account0_amount;
		var account1_amount;

		return token.transfer(accounts[1], 10000, {from:accounts[0]}).then(function(result){
			return token.balanceOf.call(accounts[0]);
		}).then(function(amount){
			account0_amount = amount.toNumber();
			return token.balanceOf.call(accounts[1]);
		}).then(function(amount){
			account1_amount = amount.toNumber();
			assert.equal(account0_amount, 99990000, "the first account");
			assert.equal(account1_amount, 10000, "the second account");
		});
	});
	});

	it("Check approve and allowance", function(){
	return MyCoin.deployed().then(function(instance){
		var token = instance;
		var allowance_0_2_amount;
		var allowance_2_3_amount;

		return token.approve(accounts[2], 8000, {from:accounts[0]}).then(function(result){
		return token.approve(accounts[3], 5000, {from:accounts[2]}).then(function(result){
		return token.allowance(accounts[0], accounts[2]).then(function(result){
			allowance_0_2_amount = result.toNumber();
			return token.allowance(accounts[2], accounts[3]).then(function(result){
				allowance_2_3_amount = result.toNumber();
				assert.equal(allowance_0_2_amount, 8000, "Approve the first account to the second accout");
				assert.equal(allowance_2_3_amount, 5000, "Approve the second account to the third accout");
			});
		});
		});
		});	
	});
	});

	it("Check TransferFrom", function(){
	return MyCoin.deployed().then(function(instance){
		var token = instance;
		var account0_amount;
		var account2_amount;
		var account_0_2_amount;	
	
		return token.transferFrom(accounts[0], accounts[2], 6000, {from:accounts[2]}).then(function(result){
		return token.transferFrom(accounts[0], accounts[2], 1000, {from:accounts[2]}).then(function(result){
			return token.balanceOf.call(accounts[0]);
		}).then(function(amount){
			account0_amount = amount.toNumber();
			return token.balanceOf.call(accounts[2]);
		}).then(function(amount){
			account2_amount = amount.toNumber();
			return token.allowance(accounts[0], accounts[2]);
		}).then(function(amount){
			account_0_2_amount = amount.toNumber();
			assert.equal(account0_amount, 99983000, "the first account");
			assert.equal(account2_amount, 7000, "the third account");
			assert.equal(account_0_2_amount, 1000, "allowed the first account to third account")
		});
		});
		});
	});

	it("Check MintCoin", function(){
	return MyCoin.deployed().then(function(instance){

		var token = instance;		
		var totalSupply;
		var account4_amount;
		
		return token.mintCoin(accounts[4], 12000, {from:accounts[1]}).then(function(){
			return token.balanceOf.call(accounts[4]);
		}).then(function(result){	
			account4_amount = result.toNumber();
			return token.totalSupply.call();
		}).then(function(result){
			totalSupply = result.toNumber();
			assert.equal(totalSupply, 100012000, "totalSupply");
			assert.equal(account4_amount, 12000, "the 4nd account")	
		});

	});
	});

	it("Testing Negative", function(){
		var account0_amount;
		var account4_amount;

		return myc.transfer(accounts[4], 3000, {from:accounts[0]}).then(function(result){
			return myc.balanceOf.call(accounts[0]);
		}).then(function(result){
			account0_amount = result.toNumber();
			return myc.balanceOf.call(accounts[4]);
		}).then(function(result){
			account4_amount = result.toNumber();
			assert.equal(account0_amount, 99980000, "the first account");
			assert.equal(account4_amount, 15000, "the 4nd account");	
		});		
	});


	it("Testing sendTransactoin", function(){
		var account0_amount;
		var account4_amount;
		return myc.transfer.sendTransaction(accounts[4], 80000, {from:accounts[0]}).then(function(result){
			return myc.balanceOf.call(accounts[0]).then(function(result){
			account0_amount = result.toNumber();
			return myc.balanceOf.call(accounts[4]).then(function(result){
			account4_amount = result.toNumber();
			
			assert.equal(account0_amount, 99900000, "the first account");
			assert.equal(account4_amount, 95000, "the 4nd account");	
			});
		});	
		});
	});

	it("event transfer", function(){
	return myc.transfer(accounts[1], 100, {from:accounts[0]}).then(function(result){
		for(var i = 0; i < result.logs.length; i++){
			var log = result.logs[i];
			if(log.event == "Transfer"){
				assert.strictEqual(log.args._from, accounts[0]);
				assert.strictEqual(log.args._to, accounts[1]);
				assert.strictEqual(log.args._value.toNumber(), 100); 
			}
		}	
	});
	});

	it("event approval", function(){
	return myc.approve(accounts[3], 5000, {from:accounts[2]}).then(function(result){
		for(var i = 0; i < result.logs.length; i++){
			var log = result.logs[i];
			if(log.event == "Approval"){
				assert.strictEqual(log.args._from, accounts[2]);
				assert.strictEqual(log.args._to, accounts[3]);
				assert.strictEqual(log.args._value.toNumber(), 5000); 
			}
		}	
	});
	});

	it("event updateOwner", function(){
	return myc.transferOwnership(accounts[0], {from:accounts[1]}).then(function(result){
		return myc.acceptOwnership({from:accounts[0]}).then(function(result){
			for(var i = 0; i < result.logs.length; i++){
				var log = result.logs[i];
				if(log.event == "OwnerUpdate"){	
				assert.strictEqual(log.args._oldOwner, accounts[1]);
				assert.strictEqual(log.args._newOwner, accounts[0]);
				}
			}
		});
	});
	});
///////////////////////////end
});
