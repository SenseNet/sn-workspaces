Compress-Archive -Path "..\..\src\nuget\snadmin\install-workspaces\*" -Force -CompressionLevel Optimal -DestinationPath "..\..\src\nuget\content\Admin\tools\install-workspaces.zip"
nuget pack ..\..\src\SenseNet.Workspaces\Workspaces.Install.nuspec -properties Configuration=Release
