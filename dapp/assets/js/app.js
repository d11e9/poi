
var dapp = {}

window.onload = function(){

	for (var i in uDApp) {
		dapp[uDApp[i].name] = {
			address: uDApp[i].address,
			interface: uDApp[i].interface,
			bytecode: uDApp[i].bytecode,
			instance: null
		}

		if (dapp[uDApp[i].name].address)
			dapp[uDApp[i].name].instance = web3.eth.contract( JSON.parse( dapp[uDApp[i].name].interface ) ).at( dapp[uDApp[i].name].address );
	}

	var notifications = document.getElementById('notifications');

	function newNotification(msg) {
		var el = document.createElement('li');
		el.innerHTML = msg;
		notifications.appendChild( el )
	}

	if (typeof web3 === 'undefined') {
		newNotification( "Web3.js not found" )
		return;
	}

	if (!web3.currentProvider) {
		web3.setProvider( new web3.providers.HttpProvider( 'http://localhost:8545' ) );
	}

	if (!web3.isConnected()) {
		newNotification( "Unable to connect to ethereum node." );
	}


	var accountSelector = document.getElementById('account');
	var step1 = document.querySelector('.step1');
	var registeredStatus = document.getElementById('registered');
	var registerBtn = document.getElementById('register');
	var candidateCount = document.querySelector('.candidateCount')
	var currentBlockNumber = document.querySelector('.blockNumber')
	var contractAddress = document.querySelector('.contractAddress')

	var startTime = document.querySelector('.startTime')
	var registrationOver = document.querySelector('.registrationOver')

	var latestBlock;
	var genesisBlock;
	var genesisTimestamp;
	var registrationBlock;
	var registrationTimestamp;
	var commitmentBlock;

	contractAddress.innerHTML = dapp.poi.instance.address;

	web3.eth.filter('latest', function(err, result){
		update()
	})

	dapp.poi.instance.genesisBlock(function(err, blockNumber){
		console.log("Genesis block: ", blockNumber.toNumber())
		genesisBlock = blockNumber;
		web3.eth.getBlock( blockNumber, function(err, block){
			console.log( "genesisBlock: ", err, block);
			genesisTimestamp = block.timestamp * 1000;
			startTime.innerHTML = new Date(genesisTimestamp);
		})
	})

	dapp.poi.instance.registrationBlock(function(err, blockNumber){
		console.log("Registration block: ", blockNumber.toNumber())
		registrationBlock = blockNumber;
		update()
	})

	dapp.poi.instance.Registration( null, function(err,result){
		console.log( "Registration event: ", err, result);
		update()
	})

	web3.eth.getAccounts( function(err, accounts) {
		if (err) {
			console.log( err );
			newNotification( err.message );
		}
		for (var i in accounts) {
			var item = document.createElement('option');
			item.value = accounts[i];
			item.innerHTML = accounts[i];
			accountSelector.appendChild( item );
		}
	});

	accountSelector.addEventListener( 'change', function(ev){
		dapp.poi.instance.userHash.call( accountSelector.value, function(err, result){
			console.log ("userHash: ", err, result);
			var userHash = web3.toBigNumber( result );
			var registered = userHash == 0 ? false : true;
			if (!registered) {
				registerBtn.disabled = registered;
				step1.className += ' active';
			}
			else step1.className = step1.className.replace('active', '')
			registeredStatus.innerHTML = registered.toString();
		});
		update()
	});

	registerBtn.addEventListener( 'click', function(ev){
		ev.preventDefault()
		dapp.poi.instance.register.sendTransaction({
			from: accountSelector.value,
			gas: 1000000
		}, function(err, result){
			if (err) newNotification(err.message);
			console.log( err, result );
		})
		return false;
	});

	update()


	function update () {
		web3.eth.getBlockNumber( function(err, result){
			latestBlock = result;
			currentBlockNumber.innerHTML = latestBlock;
		})

		dapp.poi.instance.numUsers( function(err, result){
			console.log( "numUsers: ", err, result);
			candidateCount.innerHTML = result;
		})

		if (latestBlock && registrationBlock) {
			console.log("Blocks left for registration:", registrationBlock - latestBlock)
			if (registrationBlock - latestBlock > 0) {
				registrationTimestamp = 15 * 1000 * (registrationBlock - latestBlock)
				registrationOver.innerHTML = new Date(registrationTimestamp);
			} else {
				registrationOver.innerHTML = "Over";
			}
		}
	}

}