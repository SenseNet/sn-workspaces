Compress-Archive -Path "..\..\src\nuget\snadmin\install-workspaces\*" -Force -CompressionLevel Optimal -DestinationPath "..\..\src\nuget\content\Admin\tools\install-workspaces.zip"
nuget pack ..\..\src\SenseNet.Workspaces\Workspaces.Install.nuspec -properties Configuration=Release

nuget.exe push -Source "SenseNet" -ApiKey VSTS SenseNet.Workspaces.Install.7.0.0-beta0.2.nupkg