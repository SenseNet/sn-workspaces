<%@ Control Language="C#" AutoEventWireup="true" Inherits="SenseNet.Portal.Portlets.ContentCollectionView" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="SenseNet.Portal.Helpers" %>
<%@ Import Namespace="SenseNet.Portal.UI" %>
<%@ Import Namespace="SenseNet.Portal" %>
<%@ Import Namespace="SenseNet.ContentRepository.Storage" %>
<%@ Import Namespace="SenseNet.ContentRepository.Schema" %>
<%@ Import Namespace="SenseNet.Portal.Virtualization" %>
<%@ Import Namespace="SenseNet.ContentRepository" %>

<sn:ScriptRequest Path="$skin/scripts/sn/SN.Workspace.js" runat="server" />

<div id="sn-workspacemembers-removeconfirm">
    <div class="sn-workspacemembers-removeconfirm-text">
        <%=GetGlobalResourceObject("WorkspaceRenderers", "AreYouSure")%> <a id="sn-workspacemembers-removeconfirm-name"></a> <%=GetGlobalResourceObject("WorkspaceRenderers", "from")%> <label id="sn-workspacemembers-removeconfirm-groupname"></label> <%=GetGlobalResourceObject("WorkspaceRenderers", "from2")%>?
        <input type="hidden" id="sn-workspacemembers-removeconfirm-groupid" />
        <input type="hidden" id="sn-workspacemembers-removeconfirm-userid" />
    </div>
    <div class="sn-workspacemembers-buttoncontainer">
        <div class="sn-workspacemembers-buttondiv">
            <input type="button" class="sn-submit sn-button sn-notdisabled" value='<%=GetGlobalResourceObject("WorkspaceRenderers", "Remove")%>' onclick="SN.WorkspaceMembers.okRemove();return false;" />
            <input type="button" class="sn-submit sn-button sn-notdisabled" value='<%=GetGlobalResourceObject("WorkspaceRenderers", "Cancel")%>' onclick="SN.WorkspaceMembers.cancelRemove();return false;" />
        </div>
    </div>
</div>

<%
    var settings = new SenseNet.Search.QuerySettings { EnableAutofilters = SenseNet.Search.FilterStatus.Disabled };
    var workspaceGroups = SenseNet.Search.ContentQuery.Query("+TypeIs:Group +InTree:\"" + PortalContext.Current.ContextWorkspace.Path + "\"", settings).Nodes.ToList();
%>

<div id="sn-workspacemembers-adduser">
    <div class="sn-workspacemembers-removeconfirm-text">
        <small><%=GetGlobalResourceObject("WorkspaceRenderers", "PickUsers")%> </small><br /><br />
        <% foreach (var group in workspaceGroups.OrderBy(n => n.DisplayName))
            { %>
        <div class="sn-workspacemembers-adduser-groupdiv">
            <div class="sn-workspacemembers-adduser-leftcol">
                <img class="sn-wall-smallicon" src="/Root/Global/images/icons/16/group.png" /><%= Actions.BrowseAction(group.Path, true)%>
            </div>
            <div class="sn-workspacemembers-adduser-rightcol">
                <input class="sn-workspacemembers-groupid" type="hidden" value="<%= group.Id %>" />
                <div class="sn-workspacemembers-userpicker"></div>
                <input type="button" class="sn-submit sn-button sn-notdisabled sn-workspacemembers-adduser-pickuser" value="..." onclick="SN.WorkspaceMembers.addUserPick($(this));return false;" />
                <div style="clear:both;">
                </div>
            </div>
            <div style="clear:both;">
            </div>
        </div>
        <% } %>
    </div>
    <div class="sn-workspacemembers-buttoncontainer">
        <div class="sn-workspacemembers-buttondiv">
            <input type="button" class="sn-submit sn-button sn-notdisabled" value='<%=GetGlobalResourceObject("WorkspaceRenderers", "Add")%>' onclick="SN.WorkspaceMembers.okAdd();return false;" />
            <input type="button" class="sn-submit sn-button sn-notdisabled" value='<%=GetGlobalResourceObject("WorkspaceRenderers", "Cancel")%>' onclick="SN.WorkspaceMembers.cancelAdd();return false;" />
        </div>
    </div>
</div>

<%
    var members = new[] { new { Group = null as SenseNet.ContentRepository.Group, Member = null as Node } }.ToList();
    members.Clear();
    foreach (var groupNode in workspaceGroups)
    {
        var group = groupNode as SenseNet.ContentRepository.Group;
        if (group == null)
            continue;
        members.AddRange(group.Members.Select(m => new { Group = group, Member = m }));
    }

    var memberGroupLists = from m in members
                       orderby m.Member.NodeType.IsInstaceOfOrDerivedFrom("User") ? m.Member["FullName"] : m.Member.DisplayName
                       group m by m.Member.Id into w
                       select new { Member = w.Key, Groups = w };
    
     %>

<div class="sn-workspacemembers">
    <% var editable = (this.Parent as ContextBoundPortlet).ContextNode.Security.HasPermission(SenseNet.ContentRepository.Storage.Security.PermissionType.Save); %>

    <% if (editable) { %>
    <div class="sn-workspacemembers-addmembers">
        <img src="/Root/Global/images/icons/16/add.png" class="sn-workspacemembers-addmembersimg" />
        <span style="cursor: pointer;" onclick="SN.WorkspaceMembers.add(); return false;"><%=GetGlobalResourceObject("WorkspaceRenderers", "AddNewMembers")%></span>
    </div>
    <% } %>
    <div class="sn-workspacemembers-items">

        <%  var index = 0;
            var ids = string.Empty;
            foreach (var memberGroupList in memberGroupLists)
          {
              var groupInfos = memberGroupList.Groups.OrderBy(g => g.Group.DisplayName);
              var firstGroup = groupInfos.First();
              var node = firstGroup.Member;
                
              var content = SenseNet.ContentRepository.Content.Create(node);
              ids += node.Id.ToString() + ',';
              var name = node.NodeType.IsInstaceOfOrDerivedFrom("User") ? node["FullName"] : SNSR.GetString(node.DisplayName);
              var link = node.NodeType.IsInstaceOfOrDerivedFrom("User") ? Actions.ActionUrl(content, "Profile") : Actions.BrowseUrl(content);
              index++;
                %>
            <div class="sn-workspacemembers-item <%= index > 5 ? "sn-workspacemembers-item-hidden" : "" %>">
			    <div class="sn-workspacemembers-itemavatardiv">
				    <img src="<%= UITools.GetAvatarUrl(node) %>" style="width:32px; height:32px;" />
			    </div>
			    <div class="sn-workspacemembers-itemnamediv">
				    <a class="sn-workspacemembers-itemnamelink" href="<%= link %>"><%=name %></a><br />
                    <div>
                    <%
              foreach (var groupInfo in groupInfos)
              {
                         %>
                    <span class="sn-workspacemembers-itemremovelink" style="display:inline-block;"><%= Actions.BrowseAction(groupInfo.Group.Path, true) %>
                    <% if (editable)
                       { %>
                        <span style="color: #007DC6;cursor: pointer;" onclick="SN.WorkspaceMembers.remove($(this), <%= node.Id %>, &quot;<%= link %>&quot;, '<%= name %>', '<%= groupInfo.Group.Id %>', '<%= SNSR.GetString(groupInfo.Group.DisplayName) %>'); return false;" >
                            <img src="/Root/Global/images/icons/16/delete.png" class="sn-workspacemembers-itemremoveimg" />
                        </span>
                    <% } %>
                    </span>
                    <% } %>
                    </div>
			    </div>
			    <div style="clear:both;">
			    </div>
            </div>
        <%}
            ids = ids.TrimEnd(',');
           %>
    </div>
    <input id="sn-workspacemembers-selecteditems" type="hidden" value="<%= ids %>" />

    
    <% if (index > 5) { %>
        <div class="sn-workspacemembers-showall">
            <span style="color: #007DC6;cursor: pointer;" onclick="SN.WorkspaceMembers.showAll($(this)); return false;"><%= SNSR.GetString("$WorkspaceRenderers:ShowAll_1", index) %></span>
        </div>
    <% } %>
</div>
