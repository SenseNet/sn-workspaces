$srcPath = [System.IO.Path]::GetFullPath(($PSScriptRoot + '\..\..\src'))
$installPackageFolder = "$srcPath\nuget\content\Admin\tools"
$installPackagePath = "$installPackageFolder\install-workspaces.zip"

# delete existing packages
Remove-Item $PSScriptRoot\*.nupkg

if (!(Test-Path $installPackageFolder))
{
	New-Item $installPackageFolder -Force -ItemType Directory
}

Compress-Archive -Path "$srcPath\nuget\snadmin\install-workspaces\*" -Force -CompressionLevel Optimal -DestinationPath $installPackagePath

nuget pack $srcPath\SenseNet.Workspaces\Workspaces.nuspec -properties Configuration=Release -OutputDirectory $PSScriptRoot
nuget pack $srcPath\SenseNet.Workspaces\Workspaces.Install.nuspec -properties Configuration=Release -OutputDirectory $PSScriptRoot