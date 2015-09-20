
var Earth = {
	circum:40075e3,
	radius:6371e3
}


var Point = function (x, y) {
	this.x = x
	this.y = y
	this.toString = function(){ return "(" + this.x + ", " + this.y + ")"}
}

var Point3D = function (x, y, z) {
	this.x = x
	this.y = y
	this.z = z
}

var GeoPoint = function (lon, lat, rad) {
	this.lon = lon
	this.lat = lat
	this.rad = rad
	this.toString = function(){ return "(" + this.lon + ", " + this.lat + ": " + this.rad + ")"}
	this.toPlane = function(o){
		if (!o) return null
			var x = (this.lon - o.lon) * Math.cos(geo2Rad(o.lat)) * Earth.circum/360, y = -(this.lat - o.lat) * Earth.circum/360
		return new Point(x , y)
	}
}


var Polygon = function(points){
	this.points = points?points:[]
	this.toString = function(){ return "[" + this.points.join(" ") + "]"}
	this.valueAt = function(index) {return this.points.slice(index)[0]}
	Object.defineProperty(this, "length", { get: function () {
		return this.points?this.points.length:0
	}})
	this.push = function(point){
		if (isNaN(point.x)||isNaN(point.y)) return false
		this.points.push(point)
		return true
	}
}

var GeoPolygon = function(points){
	this.points = points?points:[]
	this.toString = function(){ return "[" + this.points.join(" ") + "]"}
	this.valueAt = function(index) {return this.points.slice(index)[0]}
	Object.defineProperty(this, "length", { get: function () {
		return this.points?this.points.length:0
	}})
	this.push = function(point){
		if (isNaN(point.lon)||isNaN(point.lat)||isNaN(point.rad)) return false
		this.points.push(point)
		return true
	}
}


function linear(a, b, u){
	return a*(1-u) + b*u
}

function distance2(p0, p1){
	return Math.sqrt(Math.pow((p0.x-p1.x), 2) + Math.pow((p0.y-p1.y), 2))
}

function cProd2(p0, p1, p2){
	return (p1.x - p0.x)*(p2.y - p0.y) - (p1.y - p0.y)*(p2.x - p0.x)
}

function area2(p0, p1, p2){
	return cProd2(p0, p1, p2)/2
}

function intersect2(p00, p01, p10, p11){
	return (cProd2(p00, p01, p10) * cProd2(p00, p01, p11) < 0)
	&& (cProd2(p10, p11, p00) * cProd2(p10, p11, p01) < 0)
}

function angle2(p0, p1, p2){
	var a, b, c
	a = distance2(p0, p1)
	b = distance2(p0, p2)
	c = distance2(p1, p2)
	return Math.acos((a*a+b*b-c*c)/(2*a*b))
}

function dis2line(p0, p1, p2){ // p0 to p1-p2
	return Math.abs(cProd2(p0, p1, p2))/distance2(p1, p2)
}


// // // // // // // // // // // // // // // // // // // 

function geo2Rad(deg){
	return deg * Math.PI / 180
}

function geoDistance2(p0, p1){
	return geoAngleC(p0, p1) * Earth.radius
}

function geoAngleC(p0, p1){
// 	var d_lon = geo2Rad(p0.lon - p1.lon), d_lat = geo2Rad(p0.lat - p1.lat)
// 	return 2 * Math.asin(Math.sqrt(
// 		Math.pow(Math.sin(d_lat/2), 2) +
// 		Math.pow(Math.sin(d_lon/2), 2) *
// 		Math.cos(geo2Rad(p0.lat)) * Math.cos(geo2Rad(p1.lat))))
	return Math.acos(geoCosC(p0, p1))
}

function geoCosC(p0, p1){
	var d_lon = geo2Rad(p0.lon - p1.lon)
	return Math.sin(geo2Rad(p0.lat)) * Math.sin(geo2Rad(p1.lat))
		+ Math.cos(geo2Rad(p0.lat)) * Math.cos(geo2Rad(p1.lat))
		* Math.cos(d_lon)
}

function geoAngle2(p0, p1, p2){
	var t1 = geoCosC(p0, p1), t2 = geoCosC(p0, p2)
	return Math.acos(
		(geoCosC(p1, p2) - t1 * t2)
		/ (Math.sqrt(1-t1*t1)*Math.sqrt(1-t2*t2))
	)
}

function geoAera2(poly){
	if (poly.length <= 2) return 0
	var s = 0
	for (var i=-1;i<poly.length-1;i++){
		s += geoAngle2(poly.valueAt(i), poly.valueAt(i-1), poly.valueAt(i+1))
// 		console.log(geoAngle2(poly.valueAt(i), poly.valueAt(i-1), poly.valueAt(i+1)), s)
	}
	return Math.pow(Earth.radius, 2) * (s - (poly.length - 2) * Math.PI)
}



// // // // // // // // // // // // // // // // // // // 


function approxPolyDP(poly, eps){
	function rdp(l, r, e){
		var i, p=0, q, m=0, t, ret

		console.log(l, r, e)
		for (i=l+1;i<r;i++){
			t = dis2line(poly[i], poly[l], poly[r])
			if (t>m){
				p = i
				m = t
			}
		}
		ret = []
		if (m>e){
			ret = ret.concat(rdp(l, p, distance2(poly[l], poly[p])*eps))
			ret.push(p)
			ret = ret.concat(rdp(p, r, distance2(poly[p], poly[r])*eps))
		}

		console.log(p, m, ret)
		return ret

	}
	var i, l = poly.length, p=0, q, m=0, t
	for (i=0;i<l;i++){
		t = distance2(poly[0], poly[i])
		if (t>m){
			p = i
			m = t
		}
	}
	m = 0
	for (i=0;i<l;i++){
		t = distance2(poly[p], poly[i])
		if (t>m){
			q = i
			m = t
		}
	}

	var r=[p]
	poly = poly.concat(poly.slice())
	console.log(poly.length, poly, p, q)

	if (p<q){
		r = r.concat(rdp(p, q, distance2(poly[p], poly[q])*eps))
		r.push(q)
		r = r.concat(rdp(q, l+p, distance2(poly[p], poly[q])*eps))
	}
	else {
		r = r.concat(rdp(p, l+q, distance2(poly[p], poly[q])*eps))
		r.push(q)
		r = r.concat(rdp(q, p, distance2(poly[p], poly[q])*eps))
	}
	for (i=0;i<r.length;i++){
		if (r[i]>l) r[i] -= l
	}

	console.log(r)

	return r
}

function approxPolyDPWithE(poly, es, eps){

	function rdp(l, r, e){
		var i, p=0, q, m=0, t, ret

// 		console.log("rdp:input:", l, r, e)
		for (i=l+1;i<r;i++){
			t = dis2line(poly[i], poly[l], poly[r])/es[i] - 1
			if (t>m){
				p = i
				m = t
			}
		}
		ret = []
		if (m>e){
			ret = ret.concat(rdp(l, p, distance2(poly[l], poly[p])*eps))
			ret.push(p)
			ret = ret.concat(rdp(p, r, distance2(poly[p], poly[r])*eps))
		}

// 		console.log("rdp:output:",p, m, ret)
		return ret

	}
	var i, l = poly.length, p=0, q, m=0, t
	for (i=0;i<l;i++){
		t = distance2(poly[0], poly[i]) * dis2line(poly[i], poly[i>0?i-1:l-1], poly[i+1<l?i+1:0])/es[i]
		if (t>m){
			p = i
			m = t
		}
	}
	m = 0
	for (i=0;i<l;i++){
		t = distance2(poly[p], poly[i]) * dis2line(poly[i], poly[i>0?i-1:l-1], poly[i+1<l?i+1:0])/es[i]
		if (t>m){
			q = i
			m = t
		}
	}

	var r=[p], e0 = distance2(poly[p], poly[q])*eps
	poly = poly.concat(poly.slice())
	es = es.concat(es.slice())
	console.log("appDP:input:", l, poly, p, q, e0)

	if (p<q){
		r = r.concat(rdp(p, q, e0))
		r.push(q)
		r = r.concat(rdp(q, l+p, e0))
	}
	else {
		r = r.concat(rdp(p, l+q, e0))
		r.push(q)
		r = r.concat(rdp(q, p, e0))
	}
	for (i=0;i<r.length;i++){
		if (r[i]>=l) r[i] -= l
	}

	console.log("appDP:output:", r)

	return r
}


function convHull(poly){
	var i, m, p = 0
	m = poly[0].x
	for (i=1;i<poly.length-1;i++) {
		if (poly[i].x>m){
			m = poly[i].x
			p = i
		}
	}
	var r = [p]
	var l1
	while (1){
		l1 = p
		p = l1===0?1:0
		for (i=p+1;i<poly.length;i++) {
			if (cProd2(poly[l1], poly[p], poly[i])>0)
				p = i
		}
		if (p === r[0]){
			return r
		}
		else {
			r.push(p)
		}
	}
}
