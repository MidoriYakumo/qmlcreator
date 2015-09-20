import QtQuick 2.4
import QtQuick.Layouts 1.1

import Material 0.1

Page {
	id: item1
	width: 360
	height: 480

	property alias button: button1
	property alias indicator: rectangle1.color
	property alias delay: text1.text

	property var status:{
		"offline": "#666666",
				"idle": "#6F3FFF",
				"on": "#07FF8B",
				"off": "#FF424E",
				"working": "#FF9625",
				"waiting": "#24E6FF"
	}

	ColumnLayout {
		id: columnLayout1
		anchors.rightMargin: 10
		anchors.leftMargin: 10
		anchors.bottomMargin: 10
		anchors.topMargin: 10
		anchors.fill: parent

		Rectangle {
			id: rectangle1
			height: width
			color: status.offline
			radius: width
			border.width: 0
			anchors.right: parent.right
			anchors.left: parent.left
			anchors.top: parent.top
		}

		Item {
			id: item2
			anchors.top: rectangle1.bottom
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.left: parent.left
			anchors.topMargin: 0

			Button {
				id: button1
				x: 130
				y: -32
				text: qsTr("Button")
				anchors.centerIn: parent

				elevation:2
			}

			Text {
				id: text1
				x: 279
				y: 87
				text: qsTr("0")
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 0
				anchors.right: parent.right
				anchors.rightMargin: 0
				verticalAlignment: Text.AlignBottom
				horizontalAlignment: Text.AlignRight
				font.pixelSize: 12
			}
		}
	}

	// 	tabs: navDrawer.enabled ? [] : sectionTitles
}
