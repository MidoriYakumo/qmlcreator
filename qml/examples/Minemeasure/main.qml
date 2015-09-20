import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

import QtPositioning 5.2

import "geo.js" as Geo

Item{

	anchors.fill: parent
//ApplicationWindow {
//	title: qsTr("GeoMeasure")
//	width: 480
//	height: 640

	MainForm {
		anchors.rightMargin: 0
		anchors.bottomMargin: 0
		anchors.leftMargin: 0
		anchors.topMargin: 0
		anchors.fill: parent

		property var dots:[]
		property var es:[]
		property int drag: 0

		mouse.onClicked: {
//			update()
			drag = 0
			draw = draw_edge
			canvas.requestPaint()
			update_info(info)
		}

		property bool moving:false

		mouse.onMouseXChanged: {
			move()
		}
		mouse.onMouseYChanged: {
			move()
		}

		function move(){
			if (!moving){
				moving = true
				draw = draw_edge
				if (drag === 0) update()
				drag += 1
				canvas.requestPaint()
				update_info(info)
			}
		}

		canvas.onPaint: {
			var ctx = canvas.getContext("2d")
			if (mouse.enabled) draw(ctx)
		}

		b_clear.onClicked: {
			dots = []
			es = []
			draw = draw_clear
			canvas.requestPaint()
			info = {"area":0, "circum":0, "aErr":0, "cErr":0
						, "direction":0, "curr":0}
			update_info(info)
			mouse.enabled = true
			canvas.opacity = 1
			c_eval.opacity = 0
		}


		property var info:{"area":0, "circum":0, "aErr":0, "cErr":0
			, "direction":0, "curr":0}

//		text.text: info.circum

		function update_info(info){
			info.cErr = es[0] + es.slice(-1)[0]
			for (var i = 1;i<dots.length-1;i++){
				info.cErr += es[i] * (1+Math.cos(Geo.angle2(dots[i], dots[i-1], dots[i+1])))
			}
			if (dots.length>2) {
				info.aErr = es.slice(-1)[0] * Geo.distance2(dots.slice(-2)[0], dots[0])/2
				for (var i = 1;i<dots.length-1;i++){
					info.aErr += es[i] * Geo.distance2(dots[i-1], dots[i+1])/2
				}
			}

			text.text = "S:" + Math.abs(info.area.toFixed(2))
					+ ", C:" +info.circum.toFixed(2)
					+ "\nErr(c):" +info.cErr.toFixed(2)
					+ ", Err(a):" +info.aErr.toFixed(2)
		}

		function update_info2(info){
			info.cErr = 0
			for (var i = 1;i<dots.length-1;i++){
				info.cErr += es[i] * (1+Math.cos(Geo.angle2(dots[i], dots[i-1], dots[i+1])))
			}
			info.cErr += es[0] * (1+Math.cos(Geo.angle2(dots[0], dots[dots.length-1], dots[1])))
			info.cErr += es[dots.length-1] * (1+Math.cos(Geo.angle2(dots[dots.length-1], dots[dots.length-2], dots[0])))
			if (dots.length>2) {
				info.aErr = es.slice(-1)[0] * Geo.distance2(dots.slice(-2)[0], dots[0])/2
				info.aErr += es[0] * Geo.distance2(dots.slice(-1)[0], dots[1])/2
				for (var i = 1;i<dots.length-1;i++){
					info.aErr += es[i] * Geo.distance2(dots[i-1], dots[i+1])/2
				}
			}

			text.text = "S:" + Math.abs(info.area.toFixed(2))
					+ ", C:" +info.circum.toFixed(2)
					+ "\nErr(c):" +info.cErr.toFixed(2)
					+ ", Err(a):" +info.aErr.toFixed(2)
		}

		property var draw:draw_clear

		function draw_clear(ctx){
			ctx.reset()
			ctx.stroke()
			text.color = "black"
			var tick = 50
			ctx.strokeStyle = "#22000000"
			ctx.linewidth = 1
			ctx.beginPath()
			for (var i=0;i<height/tick;i++){
				ctx.moveTo(0, i*tick)
				ctx.lineTo(width, i*tick)
			}
			for (var i=0;i<width/tick;i++){
				ctx.moveTo(i*tick, 0)
				ctx.lineTo(i*tick, height)
			}
			ctx.stroke()
			console.log("Canvas cleard.")
			return
		}

		function draw_edge(ctx){
//			ctx.save()
			var radius
			ctx.strokeStyle = "#38A0D7"
			if ((drag<2) && (dots.length>=2)) {
				ctx.lineCap = "round"
				ctx.lineWidth = canvas.width / 60
				ctx.beginPath()
				ctx.moveTo.apply(ctx, dots.slice(-2)[0])
				ctx.lineTo.apply(ctx, dots.slice(-1)[0])
				ctx.stroke()
				ctx.fillStyle = info.curr>=0?"#5523AE66":"#55FF5656"
				ctx.lineWidth = 0
				ctx.beginPath()
				ctx.moveTo.apply(ctx, dots[0])
				ctx.lineTo.apply(ctx, dots.slice(-2)[0])
				ctx.lineTo.apply(ctx, dots.slice(-1)[0])
				ctx.fill()
			}

			if ((drag>0)||(dots.length>=2)) {
				if (drag>0) {
					es[es.length-1] = Geo.distance2([mouse.mouseX, mouse.mouseY], dots.slice(-1)[0])
					console.log(drag, es[es.length-1])
				}
				radius = Math.max(es[es.length-1], canvas.width / 60)
				ctx.fillStyle = ctx.strokeStyle
				ctx.beginPath()
				ctx.ellipse(dots.slice(-1)[0][0] - radius, dots.slice(-1)[0][1] - radius, radius*2, radius*2)
				radius = Math.max(es[es.length-2], canvas.width / 60)
				console.log(es[es.length-1], es[es.length-2])
				ctx.ellipse(dots.slice(-2)[0][0] - radius, dots.slice(-2)[0][1] - radius, radius*2, radius*2)
				ctx.fill()
				ctx.stroke()
			}

			moving = false
		}

		function update(){

			if ((mouse.mouseX != 0)&&(mouse.mouseY != 0))
				dots.push([mouse.mouseX,mouse.mouseY])
			console.log(dots.slice(-1)[0])

			var p0 = dots.slice(-1)[0], p1 = dots.slice(-2)[0]
			var a = Geo.area2(dots[0], p0, p1)
			info.area += a
			info.circum += Geo.distance2(p0, p1)
			es.push(0)

			text.color = "black"
			if (a !== 0){
				var t = info.direction * a
				if (t===0){
					info.direction = a
				}
				else if (t<0){
					text.color = "red"
				}
				info.curr = t
			}

			for (var i=0;i<dots.length-2;i++){
				if (Geo.intersect2(p0, p1, dots[i], dots[i+1])){
					messageDialog.show("Path intersection detected!")
					drag = 0 - 320000
				}
			}


			update_info(info)
		}

		c_eval.onPaint:  {
			var ctx = c_eval.getContext("2d")
			if (!mouse.enabled) draw(ctx)
		}

		b_eval.onClicked: {

			messageDialog.show(src.preferredPositioningMethods)

			draw = draw_poly
			mouse.enabled = false

			var trans, dots2=[], es2=[]
			info.circum = info.area = 0
			trans = Geo.approxPolyDPWithE(dots, es, 0.05)

			for (var i in trans){
				dots2.push(dots[trans[i]])
				es2.push(es[trans[i]])
				if (i>0) {
					info.circum += Geo.distance2(dots2[i-1], dots2[i])
					info.area += Geo.area2(dots2[0], dots2[1], dots2[i])
				}
			}
			info.circum += Geo.distance2(dots2[0], dots2.slice(-1)[0])
			dots = dots2
			es = es2
			console.log(trans, dots, es)

			update_info2(info)

			c_eval.requestPaint()
			canvas.opacity = 0
			c_eval.opacity = 1

		}

		Behavior on canvas.opacity {
			   NumberAnimation { duration: 1000 }
		}

		Behavior on c_eval.opacity {
			NumberAnimation { duration: 1000 }
		}

		function draw_poly(ctx){
			draw_clear(ctx)
			ctx.strokeStyle = "#38A0D7"
			ctx.fillStyle = "#882594D9"
			ctx.lineJoin = "round"
			ctx.lineWidth = canvas.width / 60
			ctx.beginPath()
			ctx.moveTo.apply(ctx, dots[0])
			for (var i in dots){
				ctx.lineTo.apply(ctx, dots[i])
			}
			ctx.closePath()
			ctx.fill()
			ctx.stroke()

			ctx.fillStyle = ctx.strokeStyle
			ctx.beginPath()
			for (var i in dots){
				var radius = Math.max(es[i], canvas.width / 60)
				ctx.ellipse(dots[i][0] - radius, dots[i][1] - radius, radius*2, radius*2)
			}
			ctx.closePath()
			ctx.fill()
			ctx.stroke()
		}

	}

	PositionSource {
			id: src
			active: true
			preferredPositioningMethods: PositionSource.SatellitePositioningMethods

			Component.onCompleted: {
				src.start()
				src.update()
				var supPos  = "Unknown"
				if (src.supportedPositioningMethods == PositionSource.NoPositioningMethods) {
					 supPos = "NoPositioningMethods"
				} else if (src.supportedPositioningMethods == PositionSource.AllPositioningMethods) {
					 supPos = "AllPositioningMethods"
				} else if (src.supportedPositioningMethods == PositionSource.SatellitePositioningMethods) {
					 supPos = "SatellitePositioningMethods"
				} else if (src.supportedPositioningMethods == PositionSource.NonSatellitePositioningMethods) {
					 supPos = "NonSatellitePositioningMethods"
				}
				console.log("Position Source Loaded || Supported: "+supPos+" Valid: "+valid)
			}

			onPositionChanged: {
				var coord = src.position.coordinate;
				console.log("Coordinate:", coord.longitude, coord.latitude);
			}
		}

	MessageDialog {
		id: messageDialog
		title: qsTr("Warning")

		function show(caption) {
			messageDialog.text = caption;
			messageDialog.open();
		}
	}

}
