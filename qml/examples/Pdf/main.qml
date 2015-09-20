import QtQuick 2.4
import Poppler 1.0

Item {
	height:600
	width:400

	Poppler{
		id:pdf
		anchors.fill:parent
		path:"/home/macrobull/Documents/myFonts.pdf"
	}

	Text {
		text:pdf.numPages
	}

}
