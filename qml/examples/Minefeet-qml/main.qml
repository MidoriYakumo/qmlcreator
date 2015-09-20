import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

import QtPositioning 5.2
import FileIO 1.0

import "geo.js" as Geo

// ApplicationWindow {
// 	id:app
// 	title: qsTr("MineFeet")
Item {
	anchors.fill: parent
	width: 480
	height: 640
    visible: true

	MessageDialog {
		id: warning
		title: qsTr("Warning!")

		function show(caption) {
			messageDialog.text = caption;
			messageDialog.open();
		}
	}

// 	menuBar: MenuBar {
// 		Menu {
// 			title: qsTr("&Action")
// 			MenuItem {
// 				id: a_touch
// 				text: qsTr("&Touch")
// 			}
// 			MenuItem {
// 				id: a_test
// 				text: qsTr("T&est")
// 				onTriggered: b_test.visible = !b_test.visible
// 			}
// 			MenuItem {
// 				id: a_conv
// 				text: qsTr("&Convex ")
// 				checkable:true
// 				checked: false
// 			}
// 			MenuItem {
// 				text: qsTr("E&xit")
// 				onTriggered: {console.log("Exit.");Qt.quit();}
// 			}
// 		}
// 	}


	FileIO {
		id: file
	}

	PositionSource {
		id: gps
		active: true
//		updateInterval: 5000
		preferredPositioningMethods: PositionSource.SatellitePositioningMethods

		Component.onCompleted: {
			start()
			update()
			var supPos  = "Unknown"
			if (gps.supportedPositioningMethods == PositionSource.NoPositioningMethods) {
				supPos = "NoPositioningMethods"
			} else if (gps.supportedPositioningMethods == PositionSource.AllPositioningMethods) {
				supPos = "AllPositioningMethods"
			} else if (gps.supportedPositioningMethods == PositionSource.SatellitePositioningMethods) {
				supPos = "SatellitePositioningMethods"
			} else if (gps.supportedPositioningMethods == PositionSource.NonSatellitePositioningMethods) {
				supPos = "NonSatellitePositioningMethods"
			}
			console.log("Position Source Loaded || Supported: "+supPos+" Valid: "+valid)
		}

		property var lastLocation: null

		onPositionChanged: {
			var pos = new Geo.GeoPoint(gps.position.coordinate.longitude,
								   gps.position.coordinate.latitude,
								   gps.position.horizontalAccuracy)
			if (lastLocation && (lastLocation.lon === pos.lon)
					&& (lastLocation.lat === pos.lat)
					&& (lastLocation.rad <= pos.rad)) return
			lastLocation = pos
			console.log("GPS:location:", pos)
			if (!form.update_enable) { console.log("Form GPS:Update disabled.");return}
			if (pushMerge(pos)){
				if (poly.length === 0) {
					origin = pos
				}
				pos = pos.toPlane(origin)
				pos.x += form.c_show.width/2
				pos.y += form.c_show.height/2
				poly.push(pos)

				form.update_edge()
				form.update_info()
			}
		}
	}

	property var gpoly: new Geo.GeoPolygon()
	property var poly: new Geo.Polygon()
	property var origin: null


	function pushMerge(gp){
		if (isNaN(gp.lon)||isNaN(gp.lat)||isNaN(gp.rad)) return false
		if ((gpoly.length>0) && (origin)) {
			var glast = gpoly.points[gpoly.length - 1]
			var p = gp.toPlane(glast)

			console.log("Merge delta:", p)
			var s = p.x*p.x + p.y*p.y
			if ((Math.pow(glast.rad, 2)<s) && (s<=Math.pow(gp.rad, 2))) return false
			if (s <= Math.pow(Math.min(gp.rad, glast.rad), 2)) {
				glast.lon = Geo.linear(glast.lon, gp.lon, glast.rad/(glast.rad + gp.rad))
				glast.lat = Geo.linear(glast.lat, gp.lat, glast.rad/(glast.rad + gp.rad))
				glast.rad = 1/(1/glast.rad + 1/gp.rad)
				poly.points[poly.length - 1] = glast.toPlane(origin)
				poly.points[poly.length - 1].x += form.c_show.width/2
				poly.points[poly.length - 1].y += form.c_show.height/2
//				console.log("Merge:", gp, "->", glast)
				form.update_info("merge")
				return false
			}
		}

		gpoly.push(gp)
		return true
	}


	MainForm{
		id:form
		anchors.fill: parent

		property bool touchMode:false
		property bool update_enable:false
		mouse.enabled:touchMode
		flick.interactive: !mouse.enabled

		property var drawShow: draw_init
		property var drawEval: draw_init

		property real eval_scale: 1
		property var eval_center

		property var info:info0()

		function info0(){
			return {"area":0, "circum":0, "aErr":0, "cErr":0
				, "direction":0, "cdir":0}
		}

		Component.onCompleted: clear()
		
		function clear(){
			gpoly = new Geo.GeoPolygon()
			poly = new Geo.Polygon()
			origin = null
			info = info0()
			update_enable = false
			form.update_info()
			drawShow = drawEval = draw_init
			c_show.requestPaint()
			c_eval.requestPaint()
			mouse.enabled = touchMode
			update_enable = true
			c_show.opacity = 1
			c_eval.opacity = 0
			flick.contentX = (flick.contentWidth - flick.width) / 2
			flick.contentY = (flick.contentHeight - flick.height) / 2
			gc()
		}

		c_show.onPaint: {
			drawShow(c_show.getContext("2d"))
		}
		c_eval.onPaint: {
			drawEval(c_eval.getContext("2d"))
		}

		b_clear.onClicked: clear()

		b_eval.onClicked: {
			mouse.enabled = false
			update_enable = false


//			console.log("Eval poly in:", gpoly, poly)
			var storage = {"gpoly":gpoly.toString(), "poly":poly.toString()}


			var trans, poly_t, gpoly_t, rad_t=[]
			for (var i=0;i<gpoly.length;i++) rad_t.push(gpoly.valueAt(i).rad>0?gpoly.valueAt(i).rad:1)

			poly_t=new Geo.Polygon(); gpoly_t=new Geo.GeoPolygon()
			trans = Geo.approxPolyDPWithE(poly.points, rad_t, 0.01)
			console.log("Eval trans:", trans)
			for (var i=0;i<trans.length;i++){
				poly_t.push(poly.valueAt(trans[i]))
				gpoly_t.push(gpoly.valueAt(trans[i]))
			}
			poly = poly_t;gpoly = gpoly_t

			if (a_conv.checked) {
				poly_t=new Geo.Polygon(); gpoly_t=new Geo.GeoPolygon()
				trans = Geo.convHull(poly.points)
				console.log("Eval trans:", trans)
				for (var i=0;i<trans.length;i++){
					poly_t.push(poly.valueAt(trans[i]))
					gpoly_t.push(gpoly.valueAt(trans[i]))
				}
				poly = poly_t;gpoly = gpoly_t
			}

			storage.gpoly_out = gpoly.toString()
			storage.poly_out = poly.toString()
			t_info.color = "black"
			update_info("eval")
			storage.info = info
			var dn = Qt.formatDateTime(new Date(), "yyMMdd_HHmmss")
			file.setSource("/tmp/minefeet_" + dn + ".log")
			file.write(JSON.stringify(storage))
			file.setSource("/sdcard/Documents/QML Projects/Projects/Minefeet/log" + dn + ".txt")
			file.write(JSON.stringify(storage))

			if (poly.length<2) return

			var minX, minY, maxX, maxY
			minX = maxX = poly.valueAt(0).x
			minY = maxY = poly.valueAt(0).y
			for (var i=1;i<poly.length;i++){
				minX = Math.min(minX, poly.valueAt(i).x)
				maxX = Math.max(maxX, poly.valueAt(i).x)
				minY = Math.min(minY, poly.valueAt(i).y)
				maxY = Math.max(maxY, poly.valueAt(i).y)
			}
//			console.log("Eval rect:", minX, minY, maxX, maxY)
			eval_scale = Math.min(flick.width/(maxX - minX), flick.height/(maxY - minY)) * 0.8
			eval_center = new Geo.Point((maxX + minX)/2, (maxY + minY)/2)

			flick.contentX = (flick.contentWidth - flick.width) / 2
			flick.contentY = (flick.contentHeight - flick.height) / 2

			drawEval = draw_poly
			c_eval.requestPaint()
			c_show.opacity = 0
			c_eval.opacity = 1
		}

		function draw_init(ctx){
			draw_clear(ctx)
			draw_grid(ctx)
			update_enable = true
		}

		function draw_clear(ctx){
			ctx.reset()
			console.log("Canvas cleard.")
		}

		function draw_grid(ctx, scale){
//			ctx.save()
			scale = scale?scale:1
			var tickStep = 100*scale
			ctx.strokeStyle = "#22000000"
			ctx.linewidth = 1
			ctx.beginPath()
			for (var y=0;y<ctx.canvas.height;y+=tickStep){
				ctx.moveTo(0, y)
				ctx.lineTo(ctx.canvas.width, y)
			}
			for (var x=0;x<ctx.canvas.width;x+=tickStep){
				ctx.moveTo(x, 0)
				ctx.lineTo(x, ctx.canvas.height)
			}
			ctx.stroke()
			console.log("Canvas weaved.")
//			ctx.restore()

			flick.contentX = (flick.contentWidth - flick.width) / 2
			flick.contentY = (flick.contentHeight - flick.height) / 2

		}

		function draw_edge(ctx){
//			ctx.save()
			ctx.strokeStyle = "#38A0D7"
			var radius
			var p1 = poly.valueAt(-1)
			if (app.poly.length>=2) {
				ctx.lineCap = "round"
				ctx.lineWidth = 0
				ctx.fillStyle = info.cdir>=0?"#5523AE66":"#55FF5656"
				var p0 = poly.valueAt(0), p2 = poly.valueAt(-2)
				ctx.beginPath()
				ctx.moveTo(p0.x, p0.y)
				ctx.lineTo(p1.x, p1.y)
				ctx.lineTo(p2.x, p2.y)
				ctx.fill()
				ctx.lineWidth = flick.width /120
				ctx.beginPath()
				ctx.moveTo(p1.x, p1.y)
				ctx.lineTo(p2.x, p2.y)
				ctx.stroke()

				ctx.fillStyle = ctx.strokeStyle
				ctx.beginPath()
				radius = Math.max(gpoly.valueAt(-2).rad, flick.width /120)
				ctx.ellipse(p2.x - radius, p2.y - radius, radius*2, radius*2)
			}
			else {
				ctx.fillStyle = ctx.strokeStyle
				ctx.beginPath()
			}

			radius = Math.max(gpoly.valueAt(-1).rad, flick.width /120)
			ctx.ellipse(p1.x - radius, p1.y - radius, radius*2, radius*2)
			ctx.fill()
//			ctx.restore()
			
			if (2.4*Geo.distance2(p1, 
				new Geo.Point(flick.contentX + flick.width/2, flick.contentY + flick.height/2)
				)>= Math.min(flick.width, flick.height)){
				flick.contentX = p1.x - flick.width / 2
				flick.contentY = p1.y - flick.height / 2
			}
		}

		function eval_transcale(p){
			var x, y
			x = (p.x - eval_center.x) * eval_scale + c_eval.width  / 2
			y = (p.y - eval_center.y) * eval_scale + c_eval.height  / 2
			return new Geo.Point(x, y)
		}

		function draw_poly(ctx){
			console.log("EScale:",eval_scale)
			draw_clear(ctx)
			draw_grid(ctx, eval_scale)

			ctx.shadowBlur = 0
			ctx.fillStyle = "#aa2594D9"
			ctx.beginPath()
			for (var i=0;i<poly.length;i++){
				var radius = Math.max(gpoly.valueAt(i).rad * eval_scale, flick.width /120)
				p = eval_transcale(poly.valueAt(i))
				ctx.ellipse(p.x - radius, p.y - radius, radius*2, radius*2)
//				console.log("EScale:", poly.valueAt(i), p)
			}
			ctx.fill()

			ctx.strokeStyle = "#38A0D7"
			ctx.fillStyle = "#882594D9"
			ctx.lineJoin = "round"
			ctx.lineWidth = flick.width / 120
			ctx.beginPath()
			var p
			p = eval_transcale(poly.valueAt(0))
			ctx.moveTo(p.x, p.y)
			for (var i=0;i<poly.length;i++){
				p = eval_transcale(poly.valueAt(i))
				ctx.lineTo(p.x, p.y)
			}
			ctx.closePath()
			ctx.fill()
			ctx.shadowBlur = 2
			ctx.stroke()

		}

		function update_edge(){
			drawShow = draw_edge
			c_show.requestPaint()
		}

		function update_info(flag){
			console.log("Update_info flag:", flag, !flag)
			var t, p1, p2, a = 0

			if (poly.length>=2){
				p2 = poly.valueAt(-2)
				p1 = poly.valueAt(-1)
				a = Geo.area2(poly.valueAt(0), p2, p1)
				if (update_enable && !flag) {
					info.area += a
					info.circum += Geo.distance2(p2, p1)
					info.cErr = gpoly.valueAt(0).rad + gpoly.valueAt(-1).rad
					for (var i = 1;i<gpoly.length-1;i++){
						t = gpoly.valueAt(i).rad * (1+Math.cos(
														Geo.angle2(poly.valueAt(i), poly.valueAt(i-1), poly.valueAt(i+1))
														))
						info.cErr += isNaN(t)?0:t
					}
				}
				else {
					info.cErr = 0
					for (var i = -1;i<gpoly.length-1;i++){
						t = gpoly.valueAt(i).rad * (1+Math.cos(
														Geo.angle2(poly.valueAt(i), poly.valueAt(i-1), poly.valueAt(i+1))
														))
						info.cErr += isNaN(t)?0:t
					}
				}

				info.aErr = 0
				for (var i = -1;i<gpoly.length-1;i++){
					info.aErr += gpoly.valueAt(i).rad *
							Geo.distance2(poly.valueAt(i-1), poly.valueAt(i+1))
				}
			}

			if (update_enable) {
				if (flag === "merge") {
					console.log("Merge(" + gpoly.length + "):", gpoly.valueAt(-1), "=", poly.valueAt(-1))
				}
				else {
					console.log("Add(" + gpoly.length + "):", gpoly.valueAt(-1), "->", poly.valueAt(-1))
					t_info.color = "black"

					if (a !== 0){
						t = info.direction * a
						if (t===0){
							info.direction = a
						}
						else if (t<0){
							t_info.color = "red"
						}
						info.cdir = t
					}

					if (poly.length>3){
						p2 = poly.valueAt(-2)
						p1 = poly.valueAt(-1)
						for (var i=0;i<poly.length-2;i++){
							if (Geo.intersect2(p2, p1, poly.valueAt(i), poly.valueAt(i+1))){
								if (touchMode) {
									messageDialog.show("Path intersection detected!")
								}
								else t_info.color = "blue"
							}
						}
					}
				}
			}
			else if (flag === "eval"){
				info.circum = info.area = 0
				for (var i=0;i<poly.length;i++){
					info.circum += Geo.distance2(poly.valueAt(i-1), poly.valueAt(i))
					info.area += Geo.area2(poly.valueAt(0), poly.valueAt(i-1), poly.valueAt(i))
				}
			}

			info_area = Math.abs(info.area)
			info_circum = info.circum
			info_aErr = info.aErr
			info_cErr = info.cErr
			info_err = 100*info.aErr/Math.abs(info.area)
			info_n = gpoly.length
			info_r = (gpoly.length>0)?gpoly.valueAt(-1).rad:NaN
// 			t_info.text = "S:" + Math.abs(info_area.toFixed(2))
// 					+ "\, C:" +info.circum.toFixed(2)
// 					+ "\nE(s):" +info.aErr.toFixed(2)
// 					+ "\, E(c):" +info.cErr.toFixed(2)
// 					+ "\n" + (100*info.aErr/Math.abs(info.area)).toFixed(0) + "%"
// 					+ ", n=" + gpoly.length

// 			if (gpoly.length>0)
// 				t_info.text += ", r=" + gpoly.valueAt(-1).rad.toFixed(2)

//			console.log("Info:+GeoArea=", Geo.geoAera2(gpoly))
		}
		
		t_info.text: "S:" + info_area.toFixed(2)
		+ "\, C:" + info_circum.toFixed(2)
		+ "\nE(s):" + info_aErr.toFixed(2)
		+ "\, E(c):" + info_cErr.toFixed(2)
		+ "\n" + info_err.toFixed(0) + "%"
		+ ", n=" + info_n
		+ ", r=" + info_r.toFixed(2)

		property real info_area:0
		property real info_circum:0
		property real info_aErr:0
		property real info_cErr:0
		property real info_err:0
		property real info_n:0
		property real info_r:0

		Behavior on c_show.opacity {
			NumberAnimation { duration: 500 }
		}

		Behavior on c_eval.opacity {
			NumberAnimation { duration: 500 }
		}

		Behavior on flick.contentX {
			NumberAnimation { duration: 500 }
		}

		Behavior on flick.contentY {
			NumberAnimation { duration: 500 }
		}
		
		Behavior on info_area {
			NumberAnimation { duration: 300 }
		}
		Behavior on info_circum {
			NumberAnimation { duration: 300 }
		}
		Behavior on info_aErr {
			NumberAnimation { duration: 300 }
		}
		Behavior on info_cErr {
			NumberAnimation { duration: 300 }
		}
		Behavior on info_err {
			NumberAnimation { duration: 300 }
		}
		Behavior on info_r {
			NumberAnimation { duration: 300 }
		}

	}



	Button {
		id:b_test
		text:"0"
		visible:false
		onClicked: {
//			var a = [[1, 2, 3]]
//			console.log("Test:", a.concat(a).length)
			var a, b, c, d, e
			a = new Geo.Point(300, 300)
			b = new Geo.Point(300, 600)
			c = new Geo.Point(600, 300)
			e = new Geo.Polygon([a])

			var lon, lat, rad, gp
			if (origin){
				lon = gpoly.valueAt(-1).lon + (Math.random()-.5)*0.005
				lat = gpoly.valueAt(-1).lat + (Math.random()-.5)*0.005
				rad = Math.random()*50
				gp = new Geo.GeoPoint(lon, lat, rad)
			}
			else {
				lon = 120 + (Math.random()-.5)*0.005
				lat = 30 + (Math.random()-.5)*0.005
				rad = Math.random()*30
				gp = new Geo.GeoPoint(lon, lat, rad)
				origin = gp
			}

			var p
			if (pushMerge(gp)) {
				p = gp.toPlane(origin)
				p.x += form.c_show.width/2
				p.y += form.c_show.height/2
				poly.push(p)
				form.update_edge()
				form.update_info()

				console.log("Test:GeoDis:", Geo.geoDistance2(gp, gpoly.valueAt(0)))
				console.log("Test:Distan:", Geo.distance2(p, poly.valueAt(0)))
			}

		}
	}



}
