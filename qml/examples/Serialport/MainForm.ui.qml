import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
	id: item1
    width: 640
    height: 480

    property alias button3: button3
    property alias button2: button2
	property alias button1: button1
	property alias label1: label1

    RowLayout {
        anchors.centerIn: parent

        Button {
            id: button1
            text: qsTr("Press Me 1")
        }

        Button {
            id: button2
            text: qsTr("Press Me 2")
        }

		Button {
			id: button3
			text: qsTr("Press Me 3")
		}
	}

 Label {
	 id: label1
	 x: 302
	 y: 257
	 height: 25
	 text: qsTr("Label")
	 font.pointSize: 12
	 anchors.verticalCenterOffset: 26
	 anchors.horizontalCenterOffset: 1
	 anchors.verticalCenter: parent.verticalCenter
	 anchors.horizontalCenter: parent.horizontalCenter
 }
}
