<%@ Control Language="C#" AutoEventWireup="true" Inherits="SenseNet.Portal.Portlets.ContentCollectionView" %>
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

          var nowDate = DateTime.UtcNow;
          DateTime resDate;
          DateTime? lastDate = null;
          DateTime? deadLine = null;
          int elapsed = 0;
          var portlet = this.Parent as WorkspaceSummaryPortlet;
          int mediumLimit = portlet == null ? 5 : portlet.DaysMediumWarning;
          int strongLimit = portlet == null ? 20 : portlet.DaysHighWarning;

          if (DateTime.TryParse(content["ModificationDate"].ToString(), out resDate))
              lastDate = resDate;
          if (DateTime.TryParse(content["Deadline"].ToString(), out resDate))
              deadLine = resDate;
          
          // calc days from last modification
          int progressIndication = 0;
          if (lastDate.HasValue) {
              elapsed = new TimeSpan(nowDate.Ticks - lastDate.Value.Ticks).Days;
              if (elapsed <= mediumLimit)
                  progressIndication = 1;
              else if (elapsed <= strongLimit)
                  progressIndication = 2;
              else
                  progressIndication = 3;
          }
          
          %>
      
        <div class="sn-ws-listitem sn-ws-sales sn-ws-activity ui-widget ui-widget-content ui-corner-all ui-helper-clearfix">
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
                        <%= content["Description"] %>
                    </div>
                </div>
                <div class="sn-layoutgrid-column sn-layoutgrid2">
                    <div class="sn-ws-lastmodify">
                        <div><%=GetGlobalResourceObject("KPIRenderers", "Deadline")%> <big><span class='<%= "sn-date-" + content.Id + "-Deadline" %>'></span></big></div>
                        <div><%=GetGlobalResourceObject("KPIRenderers", "Modified")%>
                            <big class="sn-kpi-lastmod-<%= progressIndication %>"><span class='<%= "sn-date-" + content.Id + "-ModificationDate" %>'></span></big> <small>(<%= elapsed %> <%=GetGlobalResourceObject("KPIRenderers", "DaysAgo")%>)</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            var datePattern = '<%= System.Globalization.CultureInfo.CurrentUICulture.DateTimeFormat.ShortDatePattern %>';
            var timePattern = '<%= System.Globalization.CultureInfo.CurrentUICulture.DateTimeFormat.ShortTimePattern %>';
            var lang = '<%= System.Globalization.CultureInfo.CurrentUICulture%>';

            $(function () {

                SN.Util.setFullLocalDate('<%= "span.sn-date-" + content.Id + "-Deadline" %>', lang, '<%= content["Deadline"] %>', datePattern, timePattern);
                SN.Util.setFullLocalDate('<%= "span.sn-date-" + content.Id + "-ModificationDate" %>', lang, '<%= content["ModificationDate"] %>', datePattern, timePattern);
            });
        </script>
    <%} %>
</div>

<%} %>