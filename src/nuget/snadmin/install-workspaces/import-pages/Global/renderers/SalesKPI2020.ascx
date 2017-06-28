<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.UI.UserControl" %>

<sn:ScriptRequest ID="snchart" runat="server" Path="/Root/Global/scripts/sn/SN.Chart.js" />
<sn:CssRequest ID="foundationCss" runat="server" CSSPath="/Root/Global/styles/foundation.min.css" />
<sn:CssRequest ID="CssRequest1" runat="server" CSSPath="/Root/Global/styles/SN.Dataviz.css" />

<div class="row fullWidth title">
    <h3>Sales KPI for 2020</h3>
</div>
<div class="row fullWidth KPIstates">
    <div class="columns large-2 small-2 notext">statename</div>
</div>
<div class="salesKPI2020 row fullWidth">
    <div class="columns large-2 small-2 notext">sales KPI</div>
</div>
<div class="row fullWidth salesKPIexpectedRev">
    <div class="columns large-2 small-2">Expected revenue</div>
</div>
<div class="row fullWidth salesKPIprogress">
    <div class="columns large-2 small-2">Progress</div>
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

                var $container = $('<div class="columns large-2 small-2" id="salesKPIContainer-' + i + '"></div>').appendTo($('.salesKPI2020'));
                var $canvas = $("<canvas class='salesKPI' id='salesKPI-" + i + "' height='200' />").appendTo($('#salesKPIContainer-' + i));
                var $KPIrevenueLabels = $("<div class='columns large-2 small-2 KPIrevenueLabel'>" + SN.Util.formatNumber(item.ExpectedRevenue) + " $</div>").appendTo($('.salesKPIexpectedRev'));
                var states = $("<div class='columns large-2 small-2 state'><h5>" + trimLabel(item.DisplayName) + "</h5></div>").appendTo($('.KPIstates'));
                var $progressKPI = $("<div class='columns large-2 small-2 KPIprogress'>" + (item.Completion) * 100 + " %</div>").appendTo($('.salesKPIprogress'));

                var options = {};
                options.id = 'salesKPI-' + i;
                var percentage = createPercentage(item.Completion);
                options.data = [
                    {
                        value: percentage,
                        label: percentage + '%',
                        color: "#c0392b"
                    },
                     {
                         value: 100 - percentage,
                         color: "#e74c3c"
                     }
                ];

                options.options = {

                    showTooltips: false,
                    responsive: true
                }

                SN.Charts.initDoughnutChart(options);

            });
        });

        function trimLabel(d) {
            return d.replace(' Sales Workspace', '');
        }

        function createPercentage(d) {
            return d * 100;
        }
    })
</script>
