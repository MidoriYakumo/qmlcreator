import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1


import Material 0.1

Item {
	width: 600
	height: 720

	property alias fsh: sfx.fragmentShader
	property alias vsh: sfx.vertexShader


	property alias p1: sp1.value
	property alias p2: sp2.value
	property alias p3: sp3.value
	
	property alias btn: auto

	ColumnLayout {
		id: columnLayout1
		anchors.rightMargin: 20
		anchors.bottomMargin: 20
		anchors.leftMargin: 20
		anchors.topMargin: 20
		anchors.fill: parent

		ShaderEffect {
			id:sfx
			height:512
			width:512
			property variant source
			property alias p1: sp1.value
			property alias p2: sp2.value
			property alias p3: sp3.value
			anchors.horizontalCenter: parent.horizontalCenter
			smooth: true
				}

		Slider {
			id: sp1
			anchors.left: parent.left
			anchors.right: parent.right
		}

		Slider {
			id: sp2
			anchors.left: parent.left
			anchors.right: parent.right
		}
		Slider {
			id: sp3
			anchors.left: parent.left
			anchors.right: parent.right
		}
		
		Button{
			id:auto
			text:"Auto"
			anchors.left: parent.left
			anchors.right: parent.right
			
			elevation:2
		}
	}
}
