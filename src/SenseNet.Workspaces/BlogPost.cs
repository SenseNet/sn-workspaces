using System;
using SenseNet.ContentRepository.Schema;
using SenseNet.ContentRepository;
using SenseNet.ContentRepository.Storage;

namespace SenseNet.Portal
{
    [ContentHandler]
    public class BlogPost : GenericContent
    {
        public BlogPost(Node parent) : this(parent, null) { }
        public BlogPost(Node parent, string nodeTypeName) : base(parent, nodeTypeName) { }
        protected BlogPost(NodeToken nt) : base(nt) { }

        public const string PUBLISHEDON = "PublishedOn";
        [RepositoryProperty(PUBLISHEDON, RepositoryDataType.DateTime)]
        public DateTime PublishedOn
        {
            get { return this.GetProperty<DateTime>(PUBLISHEDON); }
            set { base.SetProperty(PUBLISHEDON, value); }
        }

        public override void Save(NodeSaveSettings settings)
        {
            base.Save(settings);
            this.MoveToFolder();
        }
        private void MoveToFolder()
        {
            DateTime pubDate;
            if (!DateTime.TryParse(this[PUBLISHEDON].ToString(), out pubDate))
                return;

            var dateFolderName = $"{pubDate.Year}-{pubDate.Month:00}";

            // check if the post is already in the proper folder
            if (this.ParentName == dateFolderName) return;

            // check if the proper folder exists
            var targetPath = RepositoryPath.Combine(this.WorkspacePath, string.Concat("Posts/", dateFolderName));
            if (!Node.Exists(targetPath))
            {
                // target folder needs to be created
                Content.CreateNew("Folder", Node.LoadNode(RepositoryPath.Combine(this.WorkspacePath, "Posts")), dateFolderName).Save();
            }

            // hide this move from journal
            this.NodeOperation = ContentRepository.Storage.NodeOperation.HiddenJournal;

            // move blog post to the proper folder
            this.MoveTo(Node.LoadNode(targetPath));
        }
        
        public override object GetProperty(string name)
        {
            switch (name)
            {
                case PUBLISHEDON:
                    return this.PublishedOn;
                default:
                    return base.GetProperty(name);
            }
        }
        public override void SetProperty(string name, object value)
        {
            switch (name)
            {
                case PUBLISHEDON:
                    this.PublishedOn = (DateTime)value;
                    break;
                default:
                    base.SetProperty(name, value);
                    break;
            }
        }
    }
}
