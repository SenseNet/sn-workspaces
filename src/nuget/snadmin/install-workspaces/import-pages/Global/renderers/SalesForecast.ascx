<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.UI.UserControl" %>

<sn:ScriptRequest ID="snchart" runat="server" Path="/Root/Global/scripts/sn/SN.Chart.js" />
<sn:CssRequest ID="foundationCss" runat="server" CSSPath="/Root/Global/styles/foundation.min.css" />
<sn:CssRequest ID="CssRequest1" runat="server" CSSPath="/Root/Global/styles/SN.Dataviz.css" />

<div class="row fullWidth title">
    <h3>Sales Forecast by States</h3>
</div>
<div class="row fullWidth forecaststates">
    <div class="columns large-2 small-2 notext">statename</div>
</div>
<div class="row fullWidth">
    <div class="columns large-2 small-2"></div>
    <div class="columns large-10 small-10">
        <canvas class="salesForecast" id='salesForecast<%=(this.Parent as Panel).Attributes["ClientID"]%>' style="width:100%;height:200px;" />
    </div>
</div>
<div class="row fullWidth revenueLabels">
    <div class="columns large-2 small-2">Target</div>    
</div>
<div class="row fullWidth chanceLabels">
    <div class="columns large-2 small-2">Chance to win</div>    
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
                  var $revenueLabels = $("<div class='columns large-2 small-2 revenueLabel'>" + SN.Util.formatNumber(item.ExpectedRevenue) + " $</div>").appendTo($('.revenueLabels'));
                  var $chanceLabels = $("<div class='columns large-2 small-2 chanceLabel'>" + (item.ChanceOfWinning) * 100 + " %</div>").appendTo($('.chanceLabels'));
                  var states = $("<div class='columns large-2 small-2 state'><h5>" + trimLabel(item.DisplayName) + "</h5></div>").appendTo($('.forecaststates'));
                  
              });

              var options = {};
              options.id = 'salesForecast' + id;
              options.data = chartData;
              options.label = ['DisplayName', trimLabel];
              options.tooltipLabel = 'Forecast';
              options.keys = [{ keys: ['ChanceOfWinning','ExpectedRevenue'], method: forecast }];
              options.colors = [
                  {
                      fillColor: "#f1c40f",
                      highlightFill: "#f39c12",
                  }
              ];

              options.options = {
                  showScale: false,
                  scaleGridLineWidth: 0,
                  scaleShowHorizontalLines: false,
                  scaleShowVerticalLines: false,
                  scaleShowGridLines: false,
                  scaleShowLabels: false,
                  scaleSteps: null,
                  barShowStroke: false,
                  barValueSpacing: 20
              }

              SN.Charts.initBarChart(options);
          });

          function trimLabel(d) {
              return d.replace(' Sales Workspace', '');
          }

          function forecast(chanceofwin, expectedrevenue) {
              return chanceofwin * expectedrevenue;
          }
      })
</script>
