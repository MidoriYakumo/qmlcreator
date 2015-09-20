import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.0

import QtGraphicalEffects 1.0

Item {
	id: root
//	width: 640
//	height: 480
	anchors.fill: parent


	//	property alias button3: button3
	//	property alias button2: button2
	//	property alias button1: button1

	Rectangle {
		id: bg
		color: "#292929"
		z: -1
		anchors.fill: parent
		border.width: 0
	}

	property string img:"qrc:/resources/images/particle1.png"

	RowLayout {
		id: rowLayout1
		height: 60
		anchors.rightMargin: 20
		anchors.leftMargin: 20
		spacing: 12
		anchors.top: parent.top
		anchors.topMargin: 10
		anchors.right: parent.right
		anchors.left: parent.left

		Image {
			id: image1
			width: height
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0
			anchors.top: parent.top
			anchors.topMargin: 0
			anchors.left: parent.left
			anchors.leftMargin: 0
			source: img
		}

		ColumnLayout {
			id: columnLayout1
			width: 60
			anchors.left: image1.right
			anchors.leftMargin: 20
			anchors.top: parent.top
			anchors.topMargin: 0
			spacing: 6
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0

			Label {
				id: label2
				width: 60
				color: "#41e8e8"
				text: qsTr("1")
				verticalAlignment: Text.AlignVCenter
				anchors.top: parent.top
				anchors.topMargin: 0
				font.pixelSize: 32
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				horizontalAlignment: Text.AlignHCenter
			}

			Rectangle {
				id: rectangle1
				width: 60
				height: 18
				color: "#ee0000"
				radius: 6
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 0
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				border.width: 0

				Label {
					id: label3
					color: "#ffffff"
					text: qsTr("EDITED")
					anchors.fill: parent
					styleColor: "#00000000"
					font.pixelSize: 15
					horizontalAlignment: Text.AlignHCenter
				}
			}
		}

		Label {
			id: label1
			color: "#41e8e8"
			text: qsTr("Stereo Full Range")
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignLeft
			anchors.left: columnLayout1.right
			anchors.leftMargin: 30
			anchors.top: parent.top
			anchors.topMargin: 0
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0
			font.pixelSize: 32
		}

		ToolButton {
			id: toolButton1
			text: "tool1"
			iconSource: img
			iconName: ""
		}

		ToolButton {
			id: toolButton2
			text: "tool2"
			iconSource: img
		}

		ToolButton {
			id: toolButton3
			text: "tool3"
			iconSource: img
		}
	}

	Rectangle {
		id: rectangle2
		height: 4
		color: "#f2d804"
		anchors.top: rowLayout1.bottom
		anchors.topMargin: 10
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		border.width: 0
	}

	Item {
		anchors.rightMargin: 20
		anchors.leftMargin: 20
		anchors.bottomMargin: 0
		anchors.top: rectangle2.bottom
		anchors.right: parent.right
		anchors.bottom: splitView1.top
		anchors.left: parent.left
		anchors.topMargin: 0

		Label {
			id: label4
			height: 40
			color: "#b3ffffff"
			text: qsTr("Parametric EQ")
			transformOrigin: Item.Center
			anchors.left: parent.left
			anchors.leftMargin: 0
			anchors.top: parent.top
			anchors.topMargin: 10
			font.pixelSize: 18
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignLeft
			Layout.columnSpan: 2
		}

		Item {
			id: item2
			width: 200
			height: 40
			anchors.top: parent.top
			anchors.topMargin: 10
			anchors.right: parent.right
			anchors.rightMargin: 0
			Layout.columnSpan: 1

			Rectangle {
				id: rectangle3
				x: -512
				y: 256
				width: 70
				height: 30
				color: "#525252"
				radius: 15
				anchors.verticalCenter: parent.verticalCenter
				anchors.right: parent.right
				anchors.rightMargin: 0
				border.width: 0

				Label {
					id: label5
					color: "#b3ffffff"
					text: qsTr("Off")
					font.pixelSize: 15
					verticalAlignment: Text.AlignVCenter
					horizontalAlignment: Text.AlignHCenter
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter
				}
			}
		}

		Plot {
			id: image2
			anchors.top: item2.bottom
			anchors.topMargin: 20
			anchors.bottom: item6.top
			anchors.bottomMargin: 10
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.left: parent.left
			anchors.leftMargin: 0
//			source: img
			Layout.columnSpan: 3

			Rectangle {
				id: pbg
				color: "#292929"
				z: -1
				anchors.fill: parent
				border.width: 0
			}
		}

		RecursiveBlur {
			anchors.fill: bgblur
			source: bgblur
			radius: 10
			loops: 10
			z: -1
		}

		Image {
			id: bgblur
//			color: "#3a7256"
//			border.width: 0
			visible:false
			source: img
			z: -1
			anchors.rightMargin: -20
			anchors.leftMargin: -20
			anchors.fill: parent

		}

		Item {
			id: item5
			anchors.left: parent.left
			width:parent.width/3
			height: 120
			anchors.bottomMargin: 10
			anchors.leftMargin: 0
			anchors.bottom: parent.bottom
			Layout.columnSpan: 1

			Rectangle {
				id: rectangle4
				color: "#2b2b2b"
				radius: 1
				border.width: 0
				opacity: 0.8
				anchors.rightMargin: 5
				anchors.fill: parent

				Text {
					id: text1
					color: "#d6d6d6"
					text: qsTr("Band Select")
					anchors.top: parent.top
					anchors.topMargin: 10
					anchors.left: parent.left
					anchors.leftMargin: 0
					anchors.right: parent.right
					anchors.rightMargin: 0
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 16
				}

				RowLayout {
					id: rowLayout4
					anchors.top: text1.bottom
					anchors.topMargin: 20
					anchors.bottom: parent.bottom
					anchors.bottomMargin: 20
					anchors.left: parent.left
					anchors.leftMargin: 0
					anchors.right: parent.right
					anchors.rightMargin: 0

					NewRad {
						text:"1"
						anchors.left: parent.left
	  anchors.leftMargin: 10
	  cs:"#66ffcc"
	  size:40
					}
					NewRad {
						text:"2"
						anchors.horizontalCenter: parent.horizontalCenter
						cs:"#ff66cc"
						checked:true
						size:60
					}
					NewRad {
						text:"3"
						anchors.right: parent.right
	  anchors.rightMargin: 10
	  cs:"#cc66ff"
	  size:40
					}
				}
			}
		}

		Item {
			id: item6
			width:parent.width*2/3
			height: 120
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 10
			anchors.right: parent.right
			anchors.rightMargin: 0
			Layout.columnSpan: 2

			ColumnLayout {
				id: columnLayout2
				anchors.bottomMargin: 0
				anchors.fill: parent

				Param {
					height: 36
					anchors.left: parent.left
					anchors.right: parent.right
					text: "Frequency"
					min: 20
					max: 20000
					unit: "Hz"

				}

				Param {
					height: 36
					anchors.left: parent.left
					anchors.right: parent.right
					text: "Gain"
					min: -20
					max: 20
					unit: "dB"

				}

				Param {
					height: 36
					anchors.left: parent.left
					anchors.right: parent.right
					text: "Q"
					min: 0.1
					max: 16
					unit: ""

				}


			}
		}

	}

	SplitView {
		id: splitView1
		y: 420
		height: 40
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 4
		anchors.left: parent.left
		anchors.leftMargin: 20
		anchors.right: parent.right
		anchors.rightMargin: 20

		RowLayout {
			id: rowLayout2
			width: 0
			spacing: 12
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: 0

			Label {
				id: label6
				color: "#ffffff"
				text: qsTr("Flatten:")
				verticalAlignment: Text.AlignTop
			}

			RadioButton {
				id: radioButton1
				text: qsTr("Flat")
				checked: true
			}

			RadioButton {
				id: radioButton2
				text: qsTr("Restore")
			}

			Item {
				id: item4
				x: 0
				width: 130
				height: 1
			}
		}

		RowLayout {
			id: rowLayout3
			width: 100
			height: 100
			spacing: 12
			anchors.verticalCenter: parent.verticalCenter

			Item {
				id: item3
				width: 10
				height: 10
			}

			Label {
				id: label7
				color: "#ffffff"
				text: qsTr("Type:")
			}

			RadioButton {
				id: radioButton4
				text: qsTr("Bell")
				checked: true
			}

			RadioButton {
				id: radioButton3
				text: qsTr("Low Shelf")
			}

			RadioButton {
				id: radioButton5
				text: qsTr("High Shelf")
			}

		}
	}



}
