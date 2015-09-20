import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2


import QSerialPort 1.0

// TabView {
// 	anchors.fill:parent
// Tab {
	
// ApplicationWindow {
// 	title: "Serial Test"
Item{
	width: 640
	height: 480
	anchors.fill: parent

	
	SerialPort{
		id: sp
	}
	

	MainForm {
		id: mainForm1

		AvailablePortsCombo {
			id:port
			x: 326
			y: 85
			anchors.horizontalCenterOffset: 69
			anchors.horizontalCenter: parent.horizontalCenter
		}
		StandardBaudCombo {
			id:baud
			x: 184
			y: 85
			anchors.horizontalCenterOffset: -60
			anchors.horizontalCenter: parent.horizontalCenter
		}
		anchors.fill: parent
		button1.onClicked: {
			console.log(port.portName, baud.baudRate)
			label1.text = sp.readLine()
		}

		button2.checkable: true
		button2.onClicked: {
			if (button2.checked) {
				sp.setup(port.portName, baud.baudRate)
				console.log('Open:', sp.open())
			}
			else {
				sp.close()
			}
		}
		button3.onClicked: {
			sp.write("2333")
		}

	}

}


// }
