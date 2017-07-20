using System.Collections.Generic;
using System.Linq;
using SenseNet.ApplicationModel;
using SenseNet.Configuration;
using SenseNet.ContentRepository;
using SenseNet.ContentRepository.Storage.Security;
using SenseNet.ContentRepository.Workspaces;
using SenseNet.ContentRepository.Storage;
using SenseNet.Search;

namespace SenseNet.Portal.Workspaces
{
    public class WorkspaceHelper
    {
        // ======================================================================================== helper classes
        public class WorkspaceGroup
        {
            public GenericContent Workspace { get; set; }
            public Group Group { get; set; }
        }
        public class WorkspaceGroupList
        {
            public GenericContent Workspace { get; set; }
            public IGrouping<GenericContent, WorkspaceGroup> Groups { get; set; }
        }
        public class ManagerData 
        {
            public string ManagerName { get; set; }
            public string ManagerUrl { get; set; }
            public string ManagerImgPath { get; set; }
        }


        // ======================================================================================== static methods
        public static IEnumerable<WorkspaceGroupList> GetWorkspaceGroupLists(User user)
        {
            // 1. query groups under workspaces
            var settings = new QuerySettings { EnableAutofilters = FilterStatus.Disabled };
            var groups = ContentQuery.Query("+TypeIs:Group +Workspace:* -InTree:@0", settings,
                new[] { RepositoryStructure.ImsFolderPath, RepositoryStructure.ContentTemplateFolderPath }).Nodes;

            // Elevation: this is a technical method that should
            // always return the full list of relevant groups and related
            // workspaces, regardless of the current users permissions.
            using (new SystemAccount())
            {
                // 2. select groups in which the current user is a member (Owner, Editor)
                var wsGroups = groups.Select(g => new WorkspaceGroup
                {
                    Workspace = ((Group) g).Workspace,
                    Group = (Group) g
                });

                wsGroups = wsGroups.Where(wsg => wsg.Workspace != null && user.IsInGroup(wsg.Group));

                // 3. group by workspaces
                var wsGroupLists = from wsg in wsGroups
                                   orderby wsg.Workspace.DisplayName
                                   group wsg by wsg.Workspace into w
                                   select new WorkspaceGroupList { Workspace = w.Key, Groups = w };

                return wsGroupLists; 
            }
        }
        public static IEnumerable<Node> GetViaGroups(User user, WorkspaceGroup groupInfo)
        {
            var principals = user.GetGroups();

            return groupInfo.Group.Members.Where(m => principals.Contains(m.Id)).OrderBy(m => m.DisplayName);
        }
        public static ManagerData GetManagerData(User manager)
        {
            var imgSrc = "/Root/Global/images/orgc-missinguser.png?width=48&height=48";
            var managerName = "No manager associated";
            var manUrl = string.Empty;

            if (manager != null)
            {
                managerName = manager.FullName;
                var managerC = Content.Create(manager);
                var action = ActionFramework.GetAction("Profile", managerC, null);
                manUrl = action?.Uri ?? string.Empty;
                
                var imgUrl = manager.AvatarUrl;
                if (!string.IsNullOrEmpty(imgUrl))
                    imgSrc = imgUrl + "?width=48&height=48";
            }

            return new ManagerData { ManagerName = managerName, ManagerUrl = manUrl, ManagerImgPath = imgSrc };
        }

        /// <summary>
        /// Determines if there is a user among the local group members of a workspace with the given email address.
        /// </summary>
        /// <param name="email">E-mail address of a user</param>
        /// <param name="contentPath">Path of any content in the workspace</param>
        /// <returns></returns>
        public static bool IsMemberEmail(string email, string contentPath)
        {
            if (string.IsNullOrEmpty(email))
                return false;

            var user = ContentQuery.Query("+TypeIs:User +InTree:/Root/IMS +Email:@0 .AUTOFILTERS:OFF",
                new QuerySettings { EnableAutofilters = FilterStatus.Disabled },
                email).Nodes.FirstOrDefault() as User;

            if (user == null)
                return false;

            var node = Node.LoadNode(contentPath);
            if (node == null)
                return false;

            var ws = Workspace.GetWorkspaceForNode(node);
            if (ws == null)
                return false;

            return ContentQuery.Query(SafeQueries.InTreeAndTypeIs,
                new QuerySettings { EnableAutofilters = FilterStatus.Disabled },
                ws.Path, typeof(Group).Name).Nodes.OfType<Group>().Any(user.IsInGroup);
        }
    }
}
