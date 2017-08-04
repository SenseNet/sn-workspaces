$srcPath = [System.IO.Path]::GetFullPath(($PSScriptRoot + '\..\..\src'))
$installPackagePath = "$srcPath\nuget\content\Admin\tools\install-workspaces.zip"

# delete existing packages
Remove-Item $PSScriptRoot\*.nupkg

Compress-Archive -Path "..\..\src\nuget\snadmin\install-workspaces\*" -Force -CompressionLevel Optimal -DestinationPath $installPackagePath

nuget pack $srcPath\SenseNet.Workspaces\Workspaces.nuspec -properties Configuration=Release -OutputDirectory $PSScriptRoot
nuget pack $srcPath\SenseNet.Workspaces\Workspaces.Install.nuspec -properties Configuration=Release -OutputDirectory $PSScriptRoot