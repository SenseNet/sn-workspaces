<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.UI.UserControl" %>

<sn:ScriptRequest ID="snchart" runat="server" Path="/Root/Global/scripts/sn/SN.Chart.js" />
<sn:CssRequest ID="foundationCss" runat="server" CSSPath="/Root/Global/styles/foundation.min.css" />
<sn:CssRequest ID="CssRequest1" runat="server" CSSPath="/Root/Global/styles/SN.Dataviz.css" />

<div class="row fullWidth title">
    <h3>Sales Revenues</h3>
</div>
<div class="row fullWidth revenuestates">
    <div class="columns large-2 small-2 notext">statename</div>
</div>
<div class="row fullWidth">
    <div class="columns large-2 small-2"></div>
    <div class="columns large-10 small-10">
        <canvas class="salesRevenues" id='salesRevenues<%=(this.Parent as Panel).Attributes["ClientID"]%>' style="width: 100%; height: 200px;" />
    </div>
</div>
<div class="row fullWidth goalLabels">
    <div class="columns large-2 small-2">Goal</div>
</div>
<div class="row fullWidth actualLabels">
    <div class="columns large-2 small-2">Actual revenue</div>
</div>

<script>
    $(function () {
        var chartData;
        var id = '<%=(this.Parent as Panel).Attributes["ClientID"]%>';

        var chartDataRequest = $.ajax({
            url: odata.dataRoot + '/workspaces/Sales?$select=DisplayName,Completion,ExpectedRevenue,ChanceOfWinning&$top=5&metadata=no&enableautofilters=true',
            dataType: "json",
            success: function (d) {
                chartData = d.d.results;
            }
        })


        $.when(chartDataRequest).done(function () {

            $.each(chartData, function (i, item) {
                var actualLabels = $("<div class='columns large-2 small-2 actualLabel'>" + SN.Util.formatNumber(actualRevenue(item.Completion, item.ExpectedRevenue)) + " $</div>").appendTo($('.actualLabels'));
                var goalLabels = $("<div class='columns large-2 small-2 goalLabel'>" + SN.Util.formatNumber(item.ExpectedRevenue) + " $</div>").appendTo($('.goalLabels'));
                var states = $("<div class='columns large-2 small-2 state'><h5>" + trimLabel(item.DisplayName) + "</h5></div>").appendTo($('.revenuestates'));

            });

            var options = {};
            options.id = 'salesRevenues' + id;
            options.data = chartData;
            options.label = ['DisplayName', trimLabel];
            options.keys = ['ExpectedRevenue', { key: 'Completion', method: actualRevenue }];
            options.colors = [
                {
                    fillColor: "#4B77BE",
                    highlightFill: "#3A539B",
                },
                {
                    fillColor: "#D2D7D3",
                    highlightFill: "#ABB7B7",
                }
            ];

            options.options = {

                showTooltips: false,
                showScale: false,
                scaleGridLineWidth: 0,
                scaleShowHorizontalLines: false,
                scaleShowVerticalLines: false,
                scaleShowGridLines: false,
                scaleShowLabels: false,
                scaleSteps: null,
                barShowStroke: false,
                barValueSpacing: 10,
                barDatasetSpacing: 5
            }

            SN.Charts.initBarChart(options);
        });

        function trimLabel(d) {
            return d.replace(' Sales Workspace', '');
        }
        function actualRevenue(percentage, expectedrevenue) {
            return percentage * expectedrevenue;
        }
    })
</script>
