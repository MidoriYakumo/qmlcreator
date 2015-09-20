import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.3
import Material 0.1

Rectangle {
	id: rectangle1
	color: "#2e2d2d"
	radius: 1
	border.width: 0
	z: 0
	opacity: 0.8

	property alias text: label8.text
	property string unit:"u"
	property alias value: sliderHorizontal1.value
	property alias min: sliderHorizontal1.minimumValue
	property alias max: sliderHorizontal1.maximumValue
	width: 600

	height: 40
	Item {
		id: item7
		anchors.right: parent.right
  anchors.rightMargin: 0
		anchors.bottomMargin: 0
		anchors.topMargin: 0
		anchors.left: parent.left
  anchors.bottom: parent.bottom
  anchors.top: parent.top


	Label {
		id: label8
		width: 80
		color: "#cccccc"
		text: qsTr("Frequency")
		anchors.verticalCenter: parent.verticalCenter
		horizontalAlignment: Text.AlignRight
		anchors.left: parent.left
		anchors.leftMargin: 20
	}

	Label {
		id: label9
		width: 80
		color: "#cccccc"
		text: value+unit
		font.bold: true
		anchors.verticalCenter: parent.verticalCenter
		horizontalAlignment: Text.AlignLeft
		anchors.left: label8.right
		anchors.leftMargin: 8
	}

	ToolButton {
		id: toolButton4
		anchors.left: label9.right
		anchors.leftMargin: 0
		anchors.verticalCenter: parent.verticalCenter
		iconSource: "../../../Application/applications/icons/QtIcon.png"
	}

	Label {
		id: label10
		width: 40
		color: "#cccccc"
		text: min + unit
		anchors.left: toolButton4.right
		anchors.leftMargin: 0
		anchors.verticalCenter: parent.verticalCenter
	}

	Slider {
		id: sliderHorizontal1
		width: 200
		color: "#40bb90"
		anchors.verticalCenterOffset: 5
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: label10.right
		anchors.leftMargin: 10
		anchors.right: label11.left
		anchors.rightMargin: 10
	}

	Label {
		id: label11
		width: 40
		color: "#cccccc"
		text: max + unit
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: toolButton5.left
		anchors.rightMargin: 6
	}

	ToolButton {
		id: toolButton5
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
  anchors.rightMargin: 20
  iconSource: "../../../Application/applications/icons/QtIcon.png"
	}

}
}
