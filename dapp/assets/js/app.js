

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
		web3.setProvider( new web3.providers( 'http://localhost:8545' ) );
	}

	if (!web3.isConnected()) {
		notifications.appendChild( document.createElement('li').innerHTML = "Unable to connect to ethereum node.")	
	}

	var poi = web3.eth.contract( POIContract.ABI ).at( POIContract.address );



	var accountSelector = document.getElementById('account');
	web3.eth.getAccounts( function(err, accounts) {
		for (var i in accounts) {
			var item = document.createElement('option');
			item.value = accounts[i];
			item.innerHTML = accounts[i];
			accountSelector.appendChild( item );
		}
	});
	accountSelector.addEventListener( 'change', function(ev){

	});
}