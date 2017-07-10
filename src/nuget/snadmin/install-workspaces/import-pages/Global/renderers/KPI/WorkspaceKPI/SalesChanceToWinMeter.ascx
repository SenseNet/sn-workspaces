﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.UI.UserControl" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="SenseNet.Portal.Portlets" %>
<%@ Import Namespace="SenseNet.Portal.Helpers" %>
<%@ Import Namespace="SenseNet.ContentRepository.Fields" %>

<% 
    var context = SenseNet.Portal.Virtualization.PortalContext.Current.ContextWorkspace;
    double? chanceToWin = null;
    double res;
    string chancePic = "";
    
    if (Double.TryParse(context["ChanceOfWinning"].ToString(), out res))
        chanceToWin = res * 100;

    if (chanceToWin.Value <= 10) chancePic = "10";
    else if (chanceToWin.Value <= 40)
        chancePic = "40";
    else if (chanceToWin.Value <= 50)
        chancePic = "50";
    else
        chancePic = "90";
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
<div class="sn-kpi-chance2win sn-kpi-chance-<%= chancePic %>"><%= chancePic %>%</div>

<%} %>