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

//		Slider {
//			id: sl_dp_thres
//			height:0
//			antialiasing: true
//			anchors.right: parent.right
//			anchors.rightMargin: 0
//			anchors.left: parent.left
//			anchors.leftMargin: 0
//			tickmarksEnabled: true
//			minimumValue: -0.1
//			maximumValue: 0.1
//		}

		Flickable {
			id:flick
			anchors.bottom: rowLayout1.top
			anchors.bottomMargin: 10
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.left: parent.left
			anchors.leftMargin: 0
//			anchors.top: sl_dp_thres.bottom
			anchors.top: parent.top
			anchors.topMargin: 0
			contentWidth: 3000
			contentHeight: 3000

// 			contentX: (contentWidth - width) / 2
// 			contentY: (contentHeight - height) / 2

			Canvas {
				id: canvas2
				opacity: 0
				antialiasing:true
				anchors.fill: parent
//				property var draw
			}

			Canvas {
				id: canvas1
				opacity: 1
				antialiasing:true
				anchors.fill: parent
//				property var draw

				MouseArea {
					id: mouse
					anchors.fill: parent
				}

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
				text: qsTr("Info")

			}
		}
	}

	property alias c_show: canvas1
	property alias c_eval: canvas2
	property alias b_clear: b_clear
	property alias b_eval: b_evaluate
	property alias t_info: text
	property alias mouse: mouse
	property alias flick: flick

}
