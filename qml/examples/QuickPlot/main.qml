import QtQuick 2.1
import QuickPlot 1.0

Rectangle {
	anchors.fill: parent
    visible: true
    width: 640
	height: 480

    PlotArea {
        id: plotArea
        anchors.fill: parent

        yScaleEngine: FixedScaleEngine {
            max: 1.5
            min: -1.5
        }

        items: [
            ScrollingCurve {
				id: sin1;
				numPoints: 300
			},
			ScrollingCurve {
				id: sin2;
				numPoints: 30
				color:"red"
			}
        ]
    }

    Timer {
        id: timer;
        interval: 20;
        repeat: true;
        running: true;

        property real pos: 0

        onTriggered: {
			sin1.appendDataPoint( Math.sin(pos) );
			sin2.appendDataPoint( Math.sin(pos/10) );
            pos += 0.05;
        }
    }
}
