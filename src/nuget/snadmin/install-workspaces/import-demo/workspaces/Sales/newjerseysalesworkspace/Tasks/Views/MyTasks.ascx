
    <%@ Control Language="C#" AutoEventWireup="false" Inherits="SenseNet.Portal.UI.ContentListViews.ListView" %>
    <%@ Import Namespace="SNCR=SenseNet.ContentRepository" %>
    <%@ Import Namespace="SenseNet.Portal.UI.ContentListViews" %>
    
    <sn:ListGrid ID="ViewBody"
                  DataSourceID="ViewDatasource"
                  runat="server">
      <LayoutTemplate>
        <table class="sn-listgrid  ui-widget-content">
          <thead>
            <asp:TableRow runat="server" class="ui-widget-content">
            
    <sn:ListHeaderCell  runat="server" ID="checkboxHeader" class="sn-lg-cbcol ui-state-default"><input type='checkbox' /></sn:ListHeaderCell>
    
      <sn:ListHeaderCell runat="server" class="sn-lg-col-1 sn-nowrap ui-state-default" FieldName="GenericContent.DisplayName" >      
        <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="GenericContent.DisplayName" >
          <span class="sn-sort">
            <span class="sn-sort-asc ui-icon ui-icon-carat-1-n"></span>
            <span class="sn-sort-desc ui-icon ui-icon-carat-1-s"></span>
          </span>
          <span><%= ListHelper.GetColumnTitle("GenericContent.DisplayName", this.ContextNode) %></span>
        </asp:LinkButton>
      </sn:ListHeaderCell>
    
      <sn:ListHeaderCell runat="server" class="sn-lg-col-2 sn-nowrap ui-state-default" FieldName="Task.DueDate" >      
        <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="Task.DueDate" >
          <span class="sn-sort">
            <span class="sn-sort-asc ui-icon ui-icon-carat-1-n"></span>
            <span class="sn-sort-desc ui-icon ui-icon-carat-1-s"></span>
          </span>
          <span><%= ListHelper.GetColumnTitle("Task.DueDate", this.ContextNode) %></span>
        </asp:LinkButton>
      </sn:ListHeaderCell>
    
      <sn:ListHeaderCell runat="server" class="sn-lg-col-3 sn-nowrap ui-state-default" FieldName="Task.Priority" >      
        <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="Task.Priority" >
          <span class="sn-sort">
            <span class="sn-sort-asc ui-icon ui-icon-carat-1-n"></span>
            <span class="sn-sort-desc ui-icon ui-icon-carat-1-s"></span>
          </span>
          <span><%= ListHelper.GetColumnTitle("Task.Priority", this.ContextNode) %></span>
        </asp:LinkButton>
      </sn:ListHeaderCell>
    
      <sn:ListHeaderCell runat="server" class="sn-lg-col-4 sn-nowrap ui-state-default" FieldName="Task.Status" >      
        <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="Task.Status" >
          <span class="sn-sort">
            <span class="sn-sort-asc ui-icon ui-icon-carat-1-n"></span>
            <span class="sn-sort-desc ui-icon ui-icon-carat-1-s"></span>
          </span>
          <span><%= ListHelper.GetColumnTitle("Task.Status", this.ContextNode) %></span>
        </asp:LinkButton>
      </sn:ListHeaderCell>
    
            </asp:TableRow>
          </thead>
          <tbody>
            <asp:TableRow runat="server" id="itemPlaceHolder" />
          </tbody>
        </table>
      </LayoutTemplate>
      <ItemTemplate>
        <asp:TableRow runat="server" class="sn-lg-row0 ui-widget-content">
    <asp:TableCell class="sn-lg-cbcol" runat="server" Visible="<%# (this.ShowCheckboxes.HasValue && this.ShowCheckboxes.Value) ? true : false %>">
        <input type='checkbox' value='<%# Eval("Id") %>' path='<%# Eval("Path") %>' />
      </asp:TableCell>
    
          <asp:TableCell runat="server" class="sn-lg-col-1"  >
           <sn:ActionMenu NodePath='<%# Eval("Path") %>' runat="server" Scenario="ListItem" IconName="<%# ((SenseNet.ContentRepository.Content)Container.DataItem).Icon %>" OverlayVisible="true" >
            <sn:ActionLinkButton runat='server' NodePath='<%# Eval("Path") %>' ActionName='<%# ListHelper.GetMainActionName((SenseNet.ContentRepository.Content)Container.DataItem) %>' IconVisible='false' >
          <%# ListHelper.GetValueByOutputMethod(Container.DataItem, "DisplayName") %>
            </sn:ActionLinkButton>
              <asp:Placeholder runat="server" Visible="<%# !((SNCR.Content)Container.DataItem).Security.HasPermission(SNCR.Storage.Security.PermissionType.Open) %>">
          
          <%# ListHelper.GetValueByOutputMethod(Container.DataItem, "DisplayName") %>
          
              </asp:Placeholder>
            </sn:ActionMenu>
          </asp:TableCell>
        
          <asp:TableCell runat="server" class="sn-lg-col-2"  >
          <span class='<%# "sn-date-" + SenseNet.Portal.UI.UITools.GetClassForField(Container.DataItem, "DueDate") %>'>
</span>

<script> $(function () { SN.Util.setFriendlyLocalDate('<%# "span.sn-date-" +
    SenseNet.Portal.UI.UITools.GetClassForField(Container.DataItem, "DueDate")%>', '<%= 
    System.Globalization.CultureInfo.CurrentUICulture %>', '<%# 
    (Container.DataItem as SNCR.Content).Fields.ContainsKey("DueDate")
        ? (((Container.DataItem as SNCR.Content).Fields["DueDate"].FieldSetting as SNCR.Fields.DateTimeFieldSetting).DateTimeMode == SNCR.Fields.DateTimeMode.Date 
            ? ((DateTime)Eval("Task_DueDate")).ToString("M/d/yyyy", SNCR.Fields.DateTimeField.DefaultUICulture) 
            : ((DateTime)Eval("Task_DueDate")).ToString(SNCR.Fields.DateTimeField.DefaultUICulture))
        : string.Empty %>', '<%=
    System.Globalization.CultureInfo.CurrentUICulture.DateTimeFormat.ShortDatePattern.ToUpper() %>', <%# SenseNet.Portal.UI.UITools.DisplayTime(Container.DataItem, "DueDate").ToString().ToLower()%>); }); </script>
          </asp:TableCell>
        
          <asp:TableCell runat="server" class="sn-lg-col-3"  >
          <%# Eval("Task_Priority") %>
          </asp:TableCell>
        
          <asp:TableCell runat="server" class="sn-lg-col-4"  >
          <%# Eval("Task_Status") %>
          </asp:TableCell>
        </asp:TableRow>
      </ItemTemplate>
      <AlternatingItemTemplate>
        <asp:TableRow runat="server" class="sn-lg-row1 ui-widget-content">
    <asp:TableCell class="sn-lg-cbcol" runat="server" Visible="<%# (this.ShowCheckboxes.HasValue && this.ShowCheckboxes.Value) ? true : false %>">
        <input type='checkbox' value='<%# Eval("Id") %>' path='<%# Eval("Path") %>' />
      </asp:TableCell>
    
          <asp:TableCell runat="server" class="sn-lg-col-1"  >
           <sn:ActionMenu NodePath='<%# Eval("Path") %>' runat="server" Scenario="ListItem" IconName="<%# ((SenseNet.ContentRepository.Content)Container.DataItem).Icon %>" OverlayVisible="true" >
            <sn:ActionLinkButton runat='server' NodePath='<%# Eval("Path") %>' ActionName='<%# ListHelper.GetMainActionName((SenseNet.ContentRepository.Content)Container.DataItem) %>' IconVisible='false' >
          <%# ListHelper.GetValueByOutputMethod(Container.DataItem, "DisplayName") %>
            </sn:ActionLinkButton>
              <asp:Placeholder runat="server" Visible="<%# !((SNCR.Content)Container.DataItem).Security.HasPermission(SNCR.Storage.Security.PermissionType.Open) %>">
          
          <%# ListHelper.GetValueByOutputMethod(Container.DataItem, "DisplayName") %>
          
              </asp:Placeholder>
            </sn:ActionMenu>
          </asp:TableCell>
        
          <asp:TableCell runat="server" class="sn-lg-col-2"  >
          <span class='<%# "sn-date-" + SenseNet.Portal.UI.UITools.GetClassForField(Container.DataItem, "DueDate") %>'>
</span>

<script> $(function () { SN.Util.setFriendlyLocalDate('<%# "span.sn-date-" +
    SenseNet.Portal.UI.UITools.GetClassForField(Container.DataItem, "DueDate")%>', '<%= 
    System.Globalization.CultureInfo.CurrentUICulture %>', '<%# 
    (Container.DataItem as SNCR.Content).Fields.ContainsKey("DueDate")
        ? (((Container.DataItem as SNCR.Content).Fields["DueDate"].FieldSetting as SNCR.Fields.DateTimeFieldSetting).DateTimeMode == SNCR.Fields.DateTimeMode.Date 
            ? ((DateTime)Eval("Task_DueDate")).ToString("M/d/yyyy", SNCR.Fields.DateTimeField.DefaultUICulture) 
            : ((DateTime)Eval("Task_DueDate")).ToString(SNCR.Fields.DateTimeField.DefaultUICulture))
        : string.Empty %>', '<%=
    System.Globalization.CultureInfo.CurrentUICulture.DateTimeFormat.ShortDatePattern.ToUpper() %>', <%# SenseNet.Portal.UI.UITools.DisplayTime(Container.DataItem, "DueDate").ToString().ToLower()%>); }); </script>
          </asp:TableCell>
        
          <asp:TableCell runat="server" class="sn-lg-col-3"  >
          <%# Eval("Task_Priority") %>
          </asp:TableCell>
        
          <asp:TableCell runat="server" class="sn-lg-col-4"  >
          <%# Eval("Task_Status") %>
          </asp:TableCell>
        </asp:TableRow>
      </AlternatingItemTemplate>
      <EmptyDataTemplate>
        <table class="sn-listgrid ui-widget-content">
          <thead>
          <asp:TableRow runat="server">
    <sn:ListHeaderCell  runat="server" ID="checkboxHeader" class="sn-lg-cbcol ui-state-default"><input type='checkbox' /></sn:ListHeaderCell>
    
      <sn:ListHeaderCell runat="server" class="sn-lg-col-1 sn-nowrap ui-state-default" FieldName="GenericContent.DisplayName" >      
        <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="GenericContent.DisplayName" >
          <span class="sn-sort">
            <span class="sn-sort-asc ui-icon ui-icon-carat-1-n"></span>
            <span class="sn-sort-desc ui-icon ui-icon-carat-1-s"></span>
          </span>
          <span><%= ListHelper.GetColumnTitle("GenericContent.DisplayName", this.ContextNode) %></span>
        </asp:LinkButton>
      </sn:ListHeaderCell>
    
      <sn:ListHeaderCell runat="server" class="sn-lg-col-2 sn-nowrap ui-state-default" FieldName="Task.DueDate" >      
        <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="Task.DueDate" >
          <span class="sn-sort">
            <span class="sn-sort-asc ui-icon ui-icon-carat-1-n"></span>
            <span class="sn-sort-desc ui-icon ui-icon-carat-1-s"></span>
          </span>
          <span><%= ListHelper.GetColumnTitle("Task.DueDate", this.ContextNode) %></span>
        </asp:LinkButton>
      </sn:ListHeaderCell>
    
      <sn:ListHeaderCell runat="server" class="sn-lg-col-3 sn-nowrap ui-state-default" FieldName="Task.Priority" >      
        <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="Task.Priority" >
          <span class="sn-sort">
            <span class="sn-sort-asc ui-icon ui-icon-carat-1-n"></span>
            <span class="sn-sort-desc ui-icon ui-icon-carat-1-s"></span>
          </span>
          <span><%= ListHelper.GetColumnTitle("Task.Priority", this.ContextNode) %></span>
        </asp:LinkButton>
      </sn:ListHeaderCell>
    
      <sn:ListHeaderCell runat="server" class="sn-lg-col-4 sn-nowrap ui-state-default" FieldName="Task.Status" >      
        <asp:LinkButton runat="server" CommandName="Sort" CommandArgument="Task.Status" >
          <span class="sn-sort">
            <span class="sn-sort-asc ui-icon ui-icon-carat-1-n"></span>
            <span class="sn-sort-desc ui-icon ui-icon-carat-1-s"></span>
          </span>
          <span><%= ListHelper.GetColumnTitle("Task.Status", this.ContextNode) %></span>
        </asp:LinkButton>
      </sn:ListHeaderCell>
    </asp:TableRow>
          </thead>
        </table>
        <div class="sn-warning-msg ui-widget-content ui-state-default"><asp:Literal runat="server" ID="LiteralEmpty" Text="<%$ Resources: List, EmptyList %>" /></div>
      </EmptyDataTemplate>
    </sn:ListGrid>
    <asp:Literal runat="server" id="ViewScript" />
    <sn:SenseNetDataSource ID="ViewDatasource" runat="server" />
  