# Workspaces for sensenet ECM
Workspace-related items (content types and templates, workspace dashboards and views) for the [sensenet ECM](https://github.com/SenseNet/sensenet) platform.

[![Join the chat at https://gitter.im/SenseNet/sn-workspaces](https://badges.gitter.im/SenseNet/sn-workspaces.svg)](https://gitter.im/SenseNet/sn-workspaces?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![NuGet](https://img.shields.io/nuget/v/SenseNet.Workspaces.Install.svg)](https://www.nuget.org/packages/SenseNet.Workspaces.Install)

You may install this component even if you only have the **sensenet ECM Services** main component installed. That way you'll get only the specialized workspace types like *DocumentWorkspace* or *SalesWorkspace* and their content template structure.

If you also have the **sensenet ECM WebPages** component installed (which gives you a UI framework built on *ASP.NET WebForms* on top of sensenet ECM), you'll also get UI elements for workspaces:

- rich workspace content templates
- workspace dashboards
- content list views for libraries and lists

> To learn more about the available components, please follow this link:
>
> [sensenet ECM components](http://community.sensenet.com/docs/sensenet-components)

The install package of this component also contains a **demo content structure** that you can import optionally at install time or later.

## Installation
To get started, install the NuGet package the usual way in Visual Studio:

[![NuGet](https://img.shields.io/nuget/v/SenseNet.Workspaces.Install.svg)](https://www.nuget.org/packages/SenseNet.Workspaces.Install)

> `Install-Package SenseNet.Workspaces.Install -Pre`

Open a command line and go to the *[web]\Admin\bin* folder.

Execute the install-workspaces command with the SnAdmin tool.

```text
.\snadmin install-workspaces
```

Optionally you may import demo content too:

```text
.\snadmin install-workspaces importdemo:true
```