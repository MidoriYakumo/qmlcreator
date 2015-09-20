import QtQuick 2.4

Rectangle {
	property string cs:"#ff66ffcc"
	property bool checked:false
	property alias text:text1.text
	property int size:100

	width: size
	height: size
	radius: size/2
	color: checked?cs:"#00000000"
	border.color: "#dddddd"
	border.width: checked?0:3

	 Text {
		 id: text1
		 text: qsTr("Text")
		 color: checked?"#ffffffff":cs
		 verticalAlignment: Text.AlignVCenter
		 horizontalAlignment: Text.AlignHCenter
		 anchors.fill: parent
		 font.pixelSize: 20
	 }
}
