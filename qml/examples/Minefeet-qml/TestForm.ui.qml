import QtQuick 2.4
import QtQuick.Controls 1.3

Item {
	id: item1
	width: 400
	height: 400

	Slider {
		id: sliderHorizontal1
		y: 72
		stepSize: 0.01
		antialiasing: true
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		tickmarksEnabled: true
		minimumValue: -0.1
		maximumValue: 0.1
	}
}

