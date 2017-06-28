﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.UI.UserControl" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="SenseNet.Portal.Portlets" %>
<%@ Import Namespace="SenseNet.Portal.Helpers" %>
<%@ Import Namespace="SenseNet.ContentRepository.Fields" %>

<% 
    var context = SenseNet.Portal.Virtualization.PortalContext.Current.ContextWorkspace;
    double? progress = null;
    double res;

    var nowDate = DateTime.UtcNow;
    DateTime resDate;
    DateTime? startDate = null;
    DateTime? deadLine = null;

    if (Double.TryParse(context["Completion"].ToString(), out res))
        progress = res;
    if (DateTime.TryParse(context["StartDate"].ToString(), out resDate))
        startDate = resDate;
    if (DateTime.TryParse(context["Deadline"].ToString(), out resDate))
        deadLine = resDate;

    // calc deadline progress
    int progressIndication = 0;
    if (startDate.HasValue && deadLine.HasValue && progress.HasValue)
    {
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
    }

		    
   	%>
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
<div>
	<div class="sn-kpi-light2 sn-kpi-light2-<%= progressIndication.ToString() %>"></div>
</div>

<%} %>