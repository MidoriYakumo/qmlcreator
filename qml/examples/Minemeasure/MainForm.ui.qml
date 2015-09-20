import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
	width: 480
	height: 640

	ColumnLayout {
		id: columnLayout1
		spacing: 6
		anchors.rightMargin: 10
		anchors.leftMargin: 10
		anchors.bottomMargin: 10
		anchors.topMargin: 10
		anchors.fill: parent

		Canvas {
			id: c_eval
			opacity: 0
			antialiasing:true
			anchors.bottom: rowLayout1.top
			anchors.bottomMargin: 10
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.left: parent.left
			anchors.leftMargin: 0
			anchors.top: parent.top
			anchors.topMargin: 0
		}

		Canvas {
			id: canvas
			opacity: 1
			antialiasing:true
			//			color: "#ffffff"
			anchors.bottom: rowLayout1.top
			anchors.bottomMargin: 10
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.left: parent.left
			anchors.leftMargin: 0
			anchors.top: parent.top
			anchors.topMargin: 0

			MouseArea {
				id: mouse
				anchors.fill: parent
			}

		}

		RowLayout {
			id: rowLayout1
			height: 100
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0
			anchors.right: parent.right
			anchors.rightMargin: 10
			anchors.left: parent.left
			anchors.leftMargin: 10

			Button {
				id: b_clear
				text: qsTr("Clear")
			}

			Button {
				id: b_evaluate
				text: qsTr("Eval")
			}

			Label {
				id: text
				text: qsTr("Label")

			}
		}
	}

	property alias canvas: canvas
	property alias c_eval: c_eval
	property alias b_clear: b_clear
	property alias b_eval: b_evaluate
	property alias text: text
	property alias mouse: mouse

}
