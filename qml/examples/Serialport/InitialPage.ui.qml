import QtQuick 2.4
import QtQuick.Layouts 1.1

import Material 0.1

Page {
	id: item1
    width: 640
    height: 480

    property alias button3: button3
    property alias button2: button2
	property alias button1: button1
	property alias label1: label1
	
// 	tabs: navDrawer.enabled ? [] : sectionTitles

    RowLayout {
        anchors.centerIn: parent
//         spacing: Units.dp(20)

		

        Button {
            id: button1
            elevation: 2
            text: qsTr("LIVE")
        }

        Button {
            id: button2
            elevation: 2
            text: qsTr("EDIT")
        }

		Button {
			id: button3
			elevation: 2
			text: qsTr("Designer")
		}

	}

 Label {
	 id: label1
	 x: 302
	 y: 257
	 height: 25
	 text: qsTr("Label")
	 anchors.verticalCenterOffset: 50
	 anchors.verticalCenter: parent.verticalCenter
	 anchors.horizontalCenter: parent.horizontalCenter
	 font.pointSize: 12
	 font.pixelSize: Units.dp(25)
 }
}
