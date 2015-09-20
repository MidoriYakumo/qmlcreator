import QtQuick 2.0
import CommonJS 0.2
import QtQuick.Window 2.0

Item {
	anchors.fill:parent

	Text {
		id:output
		text:"output:\n"
	}

    Component.onCompleted: {
//         CommonJS.require('./js/bootstrap.js');
        var i = 1;
        var intervalId = CommonJS.setInterval(function(){
			output.text += 'Interval call ' + i + "\n";
            if(++i > 5) {
               CommonJS.clearInterval(intervalId);
            }
        }, 10);
		var x = 4;
		output.text += x + "\n"
        CommonJS.setTimeout(function(){
            Qt.quit();
        },5000);
    }
}
