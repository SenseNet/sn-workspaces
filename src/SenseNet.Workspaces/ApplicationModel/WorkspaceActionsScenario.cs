using System.Collections.Generic;
using System.Linq;
using SenseNet.ContentRepository;
using SenseNet.ContentRepository.i18n;
using SenseNet.ContentRepository.Schema;
using SenseNet.Portal.Virtualization;

namespace SenseNet.ApplicationModel
{
    [Scenario("WorkspaceActions")]
    public class WorkspaceActionsScenario : GenericScenario
    {
        protected override IEnumerable<ActionBase> CollectActions(Content context, string backUrl)
        {
            var actList = new List<ActionBase>();
            if (context == null)
                return actList;

            // gather Add actions
            var gc = context.ContentHandler as GenericContent;
            var contentTypes = gc?.GetAllowedChildTypes().ToList() ?? new List<ContentType>();
            var addActions = new List<ActionBase>();
            var app = ApplicationStorage.Instance.GetApplication("Add", context, PortalContext.Current.DeviceName);
            if (app != null)
            {
                new List<string> {"Workspace", "DocumentLibrary", "CustomList", "ItemList"}.ForEach(
                    delegate(string contentTypeName)
                        {
                            if (contentTypes.All(ct => ct.Name != contentTypeName))
                                return;

                            var cnt = ContentType.GetByName(contentTypeName);
                            var name = ContentTemplate.HasTemplate(contentTypeName) ? ContentTemplate.GetTemplate(contentTypeName).Path : cnt.Name;
                            var addNewAction = app.CreateAction(context, backUrl, new {ContentTypeName = name, backtarget = "newcontent" });
                            if (addNewAction == null)
                                return;

                            addNewAction.Text = string.Concat( SenseNetResourceManager.Current.GetString("Portal", "AddNewActionPrefix"), Content.Create(cnt).DisplayName);
                            addNewAction.Icon = cnt.Icon;

                            addActions.Add(addNewAction);
                        });
            }

            // sort add actions by text
            addActions.Sort(new ActionComparerByText());

            actList.AddRange(addActions);

            // 'Create other' action
            if (contentTypes.Count > 0)
            {
                var createOtherAction = ActionFramework.GetAction("Create", context, backUrl, null);
                if (createOtherAction != null)
                {
                    createOtherAction.Text = SenseNetResourceManager.Current.GetString("Portal", "CreateOtherActionText");
                    actList.Add(createOtherAction);
                }
            }

            // get all remaining actions and sort them using the regular comparer (by Index)
            var baseActions = base.CollectActions(context, backUrl).ToList();
            baseActions.Sort(new ActionComparer());

            actList.AddRange(baseActions);

            return actList;
        }

        public override IComparer<ActionBase> GetActionComparer()
        {
            return null;
        }
    }
}
