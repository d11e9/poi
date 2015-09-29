

window.onload = function(){

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

	var poi = web3.eth.contract( POIContract.ABI ).at( POIContract.address );


	var accountSelector = document.getElementById('account');
	var step1 = document.querySelector('.step1');
	var registeredStatus = document.getElementById('registered');
	var registerBtn = document.getElementById('register');

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
		poi.users.call( ev.target.value, function(err, result){
			console.log (err, result);
			var registered = result[2];
			if (!registered) registerBtn.disabled = registered;
			else step1.className = step1.className.replace('active', '')
			registeredStatus.innerHTML = registered.toString();
		});
	});

	registerBtn.addEventListener( 'click', function(){
		ev.preventDefault()
		console.log( "TODO :)")
		return false;
	});
}