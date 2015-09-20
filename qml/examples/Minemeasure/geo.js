
function distance2(p0, p1){
	return Math.sqrt(Math.pow((p0[0]-p1[0]), 2) + Math.pow((p0[1]-p1[1]), 2))
}

function cProd2(p0, p1, p2){
	return (p1[0] - p0[0])*(p2[1] - p0[1]) - (p1[1] - p0[1])*(p2[0] - p0[0])
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

function concat(a, b){
	a.push.apply(a, b.slice())
	return a
}

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
			ret = concat(ret, rdp(l, p, distance2(poly[l], poly[p])*eps))
			ret.push(p)
			ret = concat(ret, rdp(p, r, distance2(poly[p], poly[r])*eps))
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
	poly = concat(poly, poly.slice())
	console.log(poly.length, poly, p, q)

	if (p<q){
		r = concat(r, rdp(p, q, distance2(poly[p], poly[q])*eps))
		r.push(q)
		r = concat(r, rdp(q, l+p, distance2(poly[p], poly[q])*eps))
	}
	else {
		r = concat(r, rdp(p, l+q, distance2(poly[p], poly[q])*eps))
		r.push(q)
		r = concat(r, rdp(q, p, distance2(poly[p], poly[q])*eps))
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

		console.log(l, r, e)
		for (i=l+1;i<r;i++){
			t = dis2line(poly[i], poly[l], poly[r])/(es[i] + 1)
			if (t>m){
				p = i
				m = t
			}
		}
		ret = []
		if (m>e){
			ret = concat(ret, rdp(l, p, distance2(poly[l], poly[p])*eps))
			ret.push(p)
			ret = concat(ret, rdp(p, r, distance2(poly[p], poly[r])*eps))
		}

		console.log(p, m, ret)
		return ret

	}
	var i, l = poly.length, p=0, q, m=0, t
	for (i=0;i<l;i++){
		t = distance2(poly[0], poly[i]) * dis2line(poly[i], poly[i>0?i-1:l-1], poly[i+1<l?i+1:0])/(es[i] + 1)
		if (t>m){
			p = i
			m = t
		}
	}
	m = 0
	for (i=0;i<l;i++){
		t = distance2(poly[p], poly[i]) * dis2line(poly[i], poly[i>0?i-1:l-1], poly[i+1<l?i+1:0])/(es[i] + 1)
		if (t>m){
			q = i
			m = t
		}
	}

	var r=[p], e0 = distance2(poly[p], poly[q])*eps/(es[p] + es[q]+ 2)*2
	poly = concat(poly, poly.slice())
	es = concat(es, es.slice())
	console.log(poly.length, poly, p, q, e0)

	if (p<q){
		r = concat(r, rdp(p, q, e0))
		r.push(q)
		r = concat(r, rdp(q, l+p, e0))
	}
	else {
		r = concat(r, rdp(p, l+q, e0))
		r.push(q)
		r = concat(r, rdp(q, p, e0))
	}
	for (i=0;i<r.length;i++){
		if (r[i]>l) r[i] -= l
	}

	console.log(r)

	return r
}
