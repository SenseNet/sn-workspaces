using System.Collections.Generic;
using Newtonsoft.Json;
using SenseNet.ApplicationModel;
using SenseNet.ContentRepository;
using SenseNet.ContentRepository.Storage;
using SenseNet.ContentRepository.Storage.Security;
using SenseNet.Portal.Virtualization;

namespace SenseNet.Portal.Workspaces
{
    public class WorkspaceApi: GenericApi
    {
        internal class GroupData
        {
            public int groupId { get; set; }
            public string ids { get; set; }
        }
        private static readonly string PlaceholderPath = "/Root/System/PermissionPlaceholders/Workspace-mvc";

        [ODataAction]
        public static void AddMembers(Content dummyContent, string data)
        {
            AssertPermission(PlaceholderPath);

            var allGroupData = JsonConvert.DeserializeObject<IEnumerable<GroupData>>(data);

            foreach (var groupData in allGroupData)
            {
                if (string.IsNullOrEmpty(groupData.ids))
                    continue;

                var group = Node.LoadNode(groupData.groupId) as Group;
                if (group == null)
                    continue;

                foreach (var idOrPath in groupData.ids.Split(','))
                {
                    var content = Content.LoadByIdOrPath(idOrPath);
                    if (content == null)
                        continue;

                    var iusr = content.ContentHandler as IUser;
                    if (iusr != null)
                        group.AddMember(iusr);
                    else
                        group.AddMember(content.ContentHandler as IGroup);
                }

                group.Save();
            }
        }

        [ODataAction]
        public static void RemoveMember(Content content, int groupId, int memberId)
        {
            AssertPermission(PlaceholderPath);

            var members = Node.LoadNode(groupId) as Group;
            if (members == null)
                return;

            var node = Node.LoadNode(memberId);
            var iusr = node as IUser;
            if (iusr != null)
            {
                members.RemoveMember(iusr);
            }
            else
            {
                members.RemoveMember(node as IGroup);
            }
            members.Save();
        }
    }
}
