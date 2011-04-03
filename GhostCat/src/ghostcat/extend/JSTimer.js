var JSTimer = {
	init: function (target) {
		this.FlashObjectID = target;
		
	},
	start: function (id,delay) {
		function call() {
			document.getElementById(JSTimer.FlashObjectID).jsTimeHandler(id);
		}
		return setInterval(call,delay);
	},
	
	stop: function (intervalID) {
		clearInterval(intervalID);
	}
}