// using $skin/scripts/sn/SN.js
// using $skin/scripts/ODataManager.js
// using $skin/scripts/dataviz/Chart.min.js

SN.Charts = {

    //initializing barchart
    initBarChart: function (options) {
        var chartContainer = document.getElementById(options.id).getContext("2d");
        if (typeof options.tooltipLabel !== 'undefined')
            options.options.tooltipTemplate = options.tooltipLabel + ": <%= SN.Util.formatNumber(value) %> $";
        new Chart(chartContainer).Bar(SN.Charts.createBarChartDataSource(options), options.options);
    },

    //initializing linechart
    initLineChart: function (options) {
        var chartContainer = document.getElementById(options.id).getContext("2d");
        new Chart(chartContainer).Line(SN.Charts.createBarChartDataSource(options), options.options);
    },

    //initializing piechart
    initPieChart: function (options) {
        var chartContainer = document.getElementById(options.id).getContext("2d");
        new Chart(chartContainer).Pie(options.data, options.options);
    },

    //initializing doughnutchart
    initDoughnutChart: function (options) {
        var chartContainer = document.getElementById(options.id).getContext("2d");
        new Chart(chartContainer).Doughnut(options.data, options.options);
    },

    //initializing polarchart
    initPolarChart: function (options) {
        var chartContainer = document.getElementById(options.id).getContext("2d");
        options.tooltipTemplate = "<%if (label){%><%=label %>: <%}%><%= SN.Util.formatNumber(value) + 'k $' %>";
        options.scaleLabel =  "<%=value%>k"
        new Chart(chartContainer).PolarArea(options.data, options);
    },

    //initializing map
    initMap: function (options) {
        // apply datamap.js config
        var map = new Datamap({
            scope: options.scope,
            element: document.getElementById(options.id),
            geographyConfig: {
                highlightBorderColor: options.highlightBorderColor,
                popupTemplate: function (geography, data) {
                    if (typeof data !== 'undefined' && data !== null)
                        return '<div class="hoverinfo">' + options.popupFormat(data[options.popupValue], data, geography)
                    else
                        return '<div class="hoverinfo">' + options.popupFormat('', data, geography)
                },
                highlightBorderWidth: options.highlightBorderWidth,
                highlightFillColor: options.highlightFillColor
            },
            projection: options.projection,
            fills: options.fills,
            data: options.data
        });
        if (typeof options.bubbles !== 'undefined') {
            map.bubbles(options.bubbles, {
                popupTemplate: function (geo, data) {
                    return ['<div class="hoverinfo">' + options.bubblePopupFormat(geo, data),
                    '</div>'].join('');
                }
            });
        }
    },

    // create datasource for barcharts or linecharts
    createBarChartDataSource: function (options) {
        var barData = {};
        barData.labels = SN.Charts.createLabels(options);
        barData.datasets = SN.Charts.createDataSets(options);
        return barData;
    },

    //// datasource can be created here for piecharts or doughnutcharts if necessarry

    //createPieChartDataSource: function (options) {
    //    var pieData = [];
    //    pieData = SN.Charts.createPieChartDataSets(options);
    //    return pieData;
    //},

    // create albels for charts
    createLabels: function (options) {
        var labels = [];

        // if simple string
        if (typeof options.label !== 'object') {
            for (var i = 0; i < options.data.length; i++) {
                labels.push(options.data[i][options.label]);
            }
        }

        // if labels are objects
        else {
            for (var i = 0; i < options.data.length; i++) {
                labels.push(options.label[1](options.data[i][options.label[0]]));
            }
        }
        return labels;
    },

    // create dataset for charts
    createDataSets: function (options) {
        var datasets = [];
        // iterate through datasetitems
        for (var i = 0; i < options.keys.length; i++) {
            var data = {};
            data.data = [];
            // apply colors in dataset (for line-or barchart)
            if (typeof options.colors[i].fillColor !== 'undefined')
                data.fillColor = options.colors[i].fillColor;
            if (typeof options.colors[i].strokeColor !== 'undefined')
                data.strokeColor = options.colors[i].strokeColor;
            if (typeof options.colors[i].highlightFill !== 'undefined')
                data.highlightFill = options.colors[i].highlightFill;
            if (typeof options.colors[i].highlightStroke !== 'undefined')
                data.highlightStroke = options.colors[i].highlightStroke;
            // if simple datastructure
            if (typeof options.keys[i] !== 'object') {
                for (var j = 0; j < options.data.length; j++) {
                    data.data.push(options.data[j][options.keys[i]]);
                }
            }
            else {
                
                // if datavalue is object (not simple string)
                if (typeof options.keys[i].keys !== 'object') {
                    for (var j = 0; j < options.data.length; j++) {
                        // datavalue in array is a simple item
                        data.data.push(options.keys[i].method(options.data[j][options.keys[i].key], options.data[j][options.keys[i - 1]]));
                    }
                }
                else {
                    for (var j = 0; j < options.data.length; j++) {
                        // datavalue in array is another object
                        data.data.push(options.keys[i].method(options.data[j][options.keys[i].keys[1]], options.data[j][options.keys[i].keys[0]]));
                    }
                }
            }
            datasets.push(data);
        }
        return datasets;
    }
}