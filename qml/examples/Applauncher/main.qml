import QtQuick 2.4
import QtQuick.Controls 1.0
import ApplicationLauncher 1.0

Item {
	anchors.fill: parent
	width: 320
	height: 120

	Application {
		id:app
		appName:"ls"
		onStateChanged: {
			console.log(state)
			if (state==0) output.text = app.stdout
		}
	}


		Label {
			id: output
			color:"black"
			text: "output"
		}

		Button {
			anchors.right: parent.right
			anchors.rightMargin:10
			anchors.bottom: parent.bottom
			anchors.bottomMargin:10
			text: "Run 'ls -l /'"
			onClicked: {
				app.arguments = "-l /"
				app.launchScript()
			}
		}

}
