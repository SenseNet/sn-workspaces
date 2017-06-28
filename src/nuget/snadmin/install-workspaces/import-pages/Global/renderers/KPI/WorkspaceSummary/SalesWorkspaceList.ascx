﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="SenseNet.Portal.Portlets.ContentCollectionView" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="SenseNet.Portal.Portlets" %>
<%@ Import Namespace="SenseNet.Portal.Helpers" %>
<%@ Import Namespace="SenseNet.ContentRepository.Fields" %>

<sn:ContextInfo runat="server" ID="newWS" />

<% string user = (SenseNet.ContentRepository.User.Current).ToString(); %>
<%if (user == "Visitor")
  {%>
   <div class="sn-pt-body-border ui-widget-content ui-corner-all">
	<div class="sn-pt-body ui-corner-all">
		<%=GetGlobalResourceObject("Portal", "WSContentList_Visitor")%>
	</div>
</div>
<% }%>

<%else
  {%>
<div class="sn-workspace-list">
    
    <sn:Toolbar runat="server">
        <sn:ToolbarItemGroup Align="left" runat="server">
            <sn:ActionMenu ID="ActionMenu1" runat="server" Scenario="New" ContextInfoID="myContext" RequiredPermissions="AddNew" CheckActionCount="True">
                <sn:ActionLinkButton ID="ActionLinkButton1" runat="server" ActionName="Add" IconUrl="/Root/Global/images/icons/16/newfile.png" ContextInfoID="newWS" Text='<%$ Resources: Scenario, New %>' CheckActionCount="True"  ParameterString="backtarget=newcontent"/>
            </sn:ActionMenu>    
        </sn:ToolbarItemGroup>
    </sn:Toolbar>

    <%foreach (var content in this.Model.Items)
      { %>
      
            <% 
          var managers = content["Manager"] as List<SenseNet.ContentRepository.Storage.Node>;
          var imgSrc = "/Root/Global/images/orgc-missinguser.png?width=64&height=64";
          var managerName = HttpContext.GetGlobalResourceObject("KPIRenderers", "NoManager") as string;
          if (managers != null) {
              var manager = managers.FirstOrDefault() as SenseNet.ContentRepository.User;
              if (manager != null) {
                  var managerC = SenseNet.ContentRepository.Content.Create(manager);
                  managerName = manager.FullName;

                  var imgUrl = SenseNet.Portal.UI.UITools.GetAvatarUrl(manager, 64, 64);
                  if (!string.IsNullOrEmpty(imgUrl))
                      imgSrc = imgUrl;
              }
          }
          double? maxRevenue = 200000000;
          double? chanceToWin = null;
          double? expectedRevenue = null;
          double? progress = null;
          double res;

          var nowDate = DateTime.UtcNow;
          DateTime resDate;
          DateTime? startDate = null;
          DateTime? deadLine = null;
          
          if (Double.TryParse(content["ChanceOfWinning"].ToString(), out res))
              chanceToWin = res * 100;
          if (Double.TryParse(content["Completion"].ToString(), out res))
              progress = res * 100;
          if (Double.TryParse(content["ExpectedRevenue"].ToString(), out res))
              expectedRevenue = res;
          if (DateTime.TryParse(content["StartDate"].ToString(), out resDate))
              startDate = resDate;
          if (DateTime.TryParse(content["Deadline"].ToString(), out resDate))
              deadLine = resDate;
          
          // calc deadline progress
          int progressIndication = 0;
          if (startDate.HasValue && deadLine.HasValue && progress.HasValue) {
              var elapsed = new TimeSpan(nowDate.Ticks - startDate.Value.Ticks).Days;
              var remaining = new TimeSpan(deadLine.Value.Ticks - startDate.Value.Ticks).Days;
              var dateProgress = (double)elapsed / (double)remaining;
              var overallProgress = dateProgress - (progress.Value);
              if (overallProgress <= 0)
                  progressIndication = 1;
              else if (overallProgress <= 0.2)
                  progressIndication = 2;
              else
                  progressIndication = 3;


              var fs = content.Fields["ExpectedRevenue"].FieldSetting as SenseNet.ContentRepository.Fields.CurrencyFieldSetting;
              var cultForField = System.Globalization.CultureInfo.GetCultureInfo(fs.Format);
              var cultCurrent = (System.Globalization.CultureInfo)System.Globalization.CultureInfo.CurrentUICulture.Clone();
              string cultureSymbol = cultForField.NumberFormat.CurrencySymbol;
              int currencyPattern = cultForField.NumberFormat.CurrencyPositivePattern;
              string thousandSeparator = cultForField.NumberFormat.CurrencyGroupSeparator;
          }
          
          %>
      
        <div class="sn-ws-listitem sn-ws-sales ui-widget ui-widget-content ui-corner-all ui-helper-clearfix">
            <div class="sn-ws-info">
                <%=GetGlobalResourceObject("KPIRenderers", "Responsible")%><br />
                <img class="sn-pic sn-pic-center" src="<%= imgSrc %>" alt="<%= managerName %>" title="<%= managerName %>" /><br />
                <strong><%= managerName %></strong><br />
            </div>
            <div class="sn-layoutgrid ui-helper-clearfix">
                <div class="sn-layoutgrid-column sn-layoutgrid1">
                    <h2 class="sn-content-title">
                        <a href="<%=Actions.BrowseUrl(content)%>"><%=HttpUtility.HtmlEncode(content.DisplayName) %></a>
                    </h2>
                     <div class="sn-content-lead">
                        <div class="sn-event-schedule">
                            <span class="sn-event-date sn-event-start">
                                <small class="sn-event-year"><%= ((DateTime)content["Deadline"]).Year%></small> 
                                <small class="sn-event-month"><%= ((DateTime)content["Deadline"]).ToString("MMM")%></small> 
                                <big class="sn-event-day"><%= ((DateTime)content["Deadline"]).Day%></big> 
                            </span>
                        </div>
                        <%= content["Description"] %>
                    </div>
                </div>
                <div class="sn-layoutgrid-column sn-layoutgrid2">
                    <div class="sn-kpi-light sn-kpi-light-<%= progressIndication.ToString() %>"></div>
                    <strong><%=GetGlobalResourceObject("KPIRenderers", "ExpectedRevenue")%></strong><div class="sn-progress sn-kpi-revenue"><span style="width:<%= expectedRevenue.HasValue ? (expectedRevenue.Value/maxRevenue.Value*100).ToString() : "0"%>%"><%= content.Fields["ExpectedRevenue"].GetFormattedValue() %></span></div>
                    <strong><%=GetGlobalResourceObject("KPIRenderers", "ChanceToWin")%></strong><div class="sn-progress sn-kpi-chance"><span style="width:<%= chanceToWin.HasValue ? chanceToWin.Value.ToString() : "0"%>%" ><%= content.Fields["ChanceOfWinning"].GetFormattedValue()%></span></div>
                    <strong><%=GetGlobalResourceObject("KPIRenderers", "Progress")%></strong><div class="sn-progress sn-kpi-progress"><span style="width:<%= progress.HasValue ? progress.Value.ToString() : "0"%>%"><%= content.Fields["Completion"].GetFormattedValue()%></span></div>
                </div>
            </div>
        </div>
        
    <%} %>
</div>

<%} %>

<script>
    $(function () {
        $('[data-percentage="True"]').append('<span style="display: inline-block;background: none">%</span>');
    });
</script>