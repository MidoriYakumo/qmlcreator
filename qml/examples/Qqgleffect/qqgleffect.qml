import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

// ApplicationWindow {
// 	title: qsTr

Item{

	width: 600
	height: 720
	anchors.fill: parent



	MainForm {
		anchors.fill: parent

		p3:1.

		fsh:"
		uniform float p1;
		uniform float p2;
		uniform float p3;

//		uniform sampler2D source;
		uniform lowp float qt_Opacity;
		varying vec2 qt_TexCoord0;
		
		#define sqr(x) (x*x)
		
		vec2 cmul(vec2 x, vec2 y){
			return vec2(x.x*y.x-x.y*y.y, x.x*y.y+x.y*y.x);
		}

		void main()
		{
			vec2 uv = qt_TexCoord0.xy - vec2(0.5, 0.5);
			
			float k=0.;
			float t=p3;
			float a=p1-.5;
			float b=p2-.5;
			
			vec2 s=uv*1.0;
			
			while ((k<1.) && (length(s)<t)){
				s = cmul(s, s) + vec2(a, b);
				k += 0.08;
			}
			
			
			
			gl_FragColor = vec4(
			length(uv)<a*.6?(a*2.)*sqr(cos(atan(uv.y,uv.x)/2. + b*3.14))+(1.-a*2.)*k:k
			, length(uv)<a*.6?(a*2.)*sqr(cos(atan(uv.y,uv.x)/2. - 1.04 + b*3.14))+(1.-a*2.)*k:k
			, length(uv)<a*.6?(a*2.)*sqr(cos(atan(uv.y,uv.x)/2. + 1.04 + b*3.14))+(1.-a*2.)*k:k
			, p3);

//			gl_FragColor = vec4(
//			length(uv)<a/2.?sqr(cos(atan(uv.y,uv.x)/2. + b)):k
//			, length(uv)<a/2.?sqr(cos(atan(uv.y,uv.x)/2. - 1.04 + b)):k
//			, length(uv)<a/2.?sqr(cos(atan(uv.y,uv.x)/2. + 1.04 + b)):k
//			, p3);
		}
		"
		
		Timer{
			id:t
			interval:20
			repeat:true

			property int st:0
			property int cnt:0
			property real step:0.05


			onTriggered: {
				switch (st) {
				case 0:
					if (parent.p3<1.) parent.p3+=step/2
					else st = 1
					break;
				case 1:
					if (parent.p1<1.) parent.p1+=step/3
					else st = 2
					break;
				case 2:
					if (parent.p2<1.) parent.p2+=step
					else st = 9
					break;
				case 9:
					if (cnt<40) cnt+=1
					else {
						cnt=0
						st = 3
					}
					break;
				case 3:
					if (parent.p2>0.) parent.p2-=step
					else st = 4
					break;
				case 4:
					if (parent.p1>0.) parent.p1-=step/3
					else st = 5
					break;
				case 5:
					if (parent.p3>0.) parent.p3-=step/2
					else {
						st = 0
						stop()
					}
					break;
				}
			}

		}

		btn.onClicked:t.running?t.stop():t.start()
	}

}
