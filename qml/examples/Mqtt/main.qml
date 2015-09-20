import QtQuick 2.4
import QtQml 2.0
import Material 0.1
import Mqtt 0.1


// ApplicationWindow {
// 	title: form.title
Item {
	anchors.fill:parent
	width: 320
	height: 480
// 	theme {
// 		primaryColor: Palette.colors["blue"]["500"]
// 		primaryDarkColor: Palette.colors["blue"]["700"]
// 		accentColor: Palette.colors["teal"]["500"]
// 		tabHighlightColor: "white"
// 	}

	property int s;
	property var st;
	property bool pending:false;
	property var server
// 		: "localhost";
		: "45.79.81.190";

	function time(){
		return new Date().getTime();
	}

	MqttClient {
		id: receiver
		host: server
		topic: "miso"
		qos: 1
		autorc:true
		onMessageReceived: {
			var d
			if (message == "ACK") {
				if (pending) form.indicator = form.status.working;
				d = 'ACK@'+(time()-st)+'ms';
				console.log(d);
				form.delay = d;
				return;
			}
			pending = false;
			if (message == "1") s = 1; else s = 0;
			if (s)
				form.indicator = form.status.on;
			else
				form.indicator = form.status.off;

			d = 'Action@'+(time()-st)+'ms';
			console.log(d);
			form.delay = d;
		}
		onDisconnected: {
			form.indicator = form.status.offline
			form.title = "Offline"
			receiver.connect();
		}
		onConnected: {
			form.indicator = form.status.idle
			form.title = "Online " + host + ":" + port
			console.log("Connected");ping();
		}
		onPong: {
			console.lo("Pong!")
		}
	}

	MqttClient {
		id: sender
		host: server
		autorc:true
		qos: 1
		topic: "mosi"
	}

	InitialPage {
		title: "Mqtt Test"
		id: form
		anchors.fill: parent

		button.text: "Toggle"
		button.onClicked: {
			pending = true;
			sender.publishMessage(1-s);
			form.indicator = status.waiting;
			st = time();
		}
	}
}
