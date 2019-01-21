using System;
using SenseNet.ContentRepository;

namespace SenseNet.Workspaces
{
    internal class WorkspacesComponent : SnComponent
    {
        public override string ComponentId { get; } = "SenseNet.Workspaces";
        public override Version SupportedVersion { get; } = new Version(7, 3, 0);
    }
}
