import QtQuick 2.4

import jbQuick.Charts 1.0
import "QChartGallery.js" as ChartsData

Chart {
	id: plot;
	height: 400
	width: 400


	chartData: ChartsData.ChartLineData;
	chartType: Charts.ChartType.LINE;
	chartOptions:ChartsData.Options;
}


