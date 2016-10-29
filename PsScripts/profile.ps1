Write-Host "hello ${env:USERNAME}, welcome ..."



Write-Host "configure path ..."

$oldPath = Get-Content Env:\Path

Set-Item Env:\Path "
    $oldPath;
    C:\hhdcommand\PortableGit\bin;
"

cat Env:\Path



Write-Host "configure output encoding as utf8 ..."
$OutputEncoding = New-Object -TypeName System.Text.UTF8Encoding



# Write-Host "configure DebugPreference ..."
# $DebugPreference = "continue"



Write-Host "configure execution policy ..."
Set-ExecutionPolicy Bypass -Scope Process -Force



<#
.SYNOPSIS
.PARAMETER modulename
.EXAMPLE
#>
function hhdmoduleinstallimport($modulename)
{
    if((Get-InstalledModule -name $modulename).count -eq 0)
    {
        Write-Host "install ${modulename} ..."
        Install-Package $modulename -Verbose
    }
    else 
    {
        Write-Host "${modulename} already installed !!!"
    }

    Write-Host "import ${modulename} ..."
    Import-Module $modulename -Verbose
}



Write-Host "import module posh-git ..."
hhdmoduleinstallimport -modulename posh-git



Write-Host "setup git prompt ..."
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}



Write-Host "cd c:\temp ..."
if($pwd -like "*WINDOWS\System32*")
{
    if(!(Test-Path \temp))
    {
        mkdir \temp
    }

    Write-Host "change directory to temp ..."
    cd \temp
}



Write-Host "setup alias ... "

Set-Alias vim "c:\hhdcommand\vim74\vim.exe"
Set-Alias sublime "c:\hhdcommand\Sublime Text 2.0.2\sublime_text.exe"
Set-Alias open "C:\Windows\SysWOW64\explorer.exe"
Set-Alias vs2013 "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\devenv.com"
Set-Alias vs2015 "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.com"
Set-Alias blend2013 "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\blend.exe"
Set-Alias blend2015 "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\blend.exe"
Set-Alias honeyview "C:\Program Files\Honeyview\Honeyview.exe"
Set-Alias sqlite3 "c:\hhdcommand\sqlite\sqlite3.exe"
Set-Alias nuget "C:\ProgramData\Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe"
Set-Alias java "C:\Program Files (x86)\Java\jdk1.7.0_55\bin\java.exe"
Set-Alias javac "C:\Program Files (x86)\Java\jdk1.7.0_55\bin\javac.exe"
Set-Alias apt "C:\Program Files (x86)\Java\jdk1.7.0_55\bin\apt.exe"
Set-Alias jar "C:\Program Files (x86)\Java\jdk1.7.0_55\bin\jar.exe"
Set-Alias javadoc "C:\Program Files (x86)\Java\jdk1.7.0_55\bin\javadoc.exe"
Set-Alias zip Compress-Archive
Set-Alias unzip Expand-Archive
Remove-Item alias:\cd
Set-Alias cd Push-Location
Set-Alias pd Pop-Location
Set-Alias nuget "C:\hhdcommand\nuget\nuget.exe"



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdcdtemp
{
    cd c:\temp
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdcdproject
{
    cd c:\project
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdsublimeprofileps1
{
    sublime c:\hhdcommand\PsDev\PsScripts\profile.ps1
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdcatprofileps1
{
    cat c:\hhdcommand\PsDev\PsScripts\profile.ps1
}



<#
.SYNOPSIS
.EXAMPLE
    PS C:\> hhdps

       Id Name                       WS(M) Path
       -- ----                       ----- ----
        4 System                       595
    18524 devenv                       426 C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe
     8188 chrome                       171 C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
    17652 chrome                       152 C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
     8600 chrome                       142 C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
     3684 chrome                       140 C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
     3696 MsMpEng                      130
    11032 PowerShellToolsProcessHost   105 C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\qablerhr.v4z\PowerShellT
                                           oolsProcessHost.exe
     3016 powershell                    93 C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
     6316 explorer                      91 C:\WINDOWS\Explorer.EXE
#>
function hhdps()
{
    ps | sort WS -Descending | select Id, Name, @{l="WS(M)"; e={[int]($_.WS / 1024 / 1024)}}, Path -First 10 | ft -AutoSize -Wrap
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdgitgraph
{
    git log --pretty=format:"%h %s - %an %ar" --graph
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdcatlog($path)
{
    cat -Wait $path
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdvspsdev()
{
    Start-Process devenv.exe -Verb runAs -ArgumentList c:\hhdcommand\PsDev\PsDev.sln
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdadblogcatmono
{
    adb logcat -s mono-stdout:v
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdazureloginauto()
{
    Write-Host "azure login ..."
    Import-AzurePublishSettingsFile ~\*.publishsettings    
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdazurecurrent()
{
    Write-Host "azure subscription check ..."
    pause
    Get-AzureSubscription



    Write-Host "azure website check ..."
    pause
    Get-AzureWebsite
    Get-AzureWebHostingPlan



    Write-Host "azure sql database check ..."
    pause
    Get-AzureSqlDatabaseServer | Get-AzureSqlDatabase | hhdazuresqldatabasedetail



    Write-Host "azure storage account check ..."
    pause
    Get-AzureStorageAccount

    Write-Host "azure storage blob check ..."
    pause
    Get-AzureStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdazurestartallwebsite()
{
    Write-Host "azure website check ..."
    Get-AzureWebSite

    Write-Host "start all websites ..."
    Get-AzureWebSite | Start-AzureWebSite

    Write-Host "azure website check ..."
    Get-AzureWebSite
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdazurestopallwebsite()
{
    Write-Host "azure website check ..."
    Get-AzureWebSite

    Write-Host "stop all websites ..."
    Get-AzureWebSite | Stop-AzureWebSite

    Write-Host "azure website check ..."
    Get-AzureWebSite
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdazuregetwebsiteloghhdyidbot()
{
    Get-AzureWebsiteLog -Name hhdyidbot -Tail
}



<#
.SYNOPSIS
.PARAMETER path
.EXAMPLE
#>
function hhdrm($path)
{
    rm -Recurse -Force $path
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdkillallpowershellwithoutme()
{
    ps -Name *powershell* | where { $_.Id -ne $PID } | kill
}



<#
.SYNOPSIS
.EXAMPLE
    hhdiotconnect -servername "minwinpc" -password "p@ssw0rd"
#>
function hhdiotconnect($servername, $password)
{
    Write-Host "start winrm service ..."
    net start winrm

    Write-Host "add TrustedHosts ..."
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $servername

    $passwordEnc = ConvertTo-SecureString $password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential("$servername\administrator", $passwordEnc)

    Write-Host "enter pssession ..."
    Enter-PSSession -ComputerName $servername -Credential $cred
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdiotconnectminwinpc()
{
    hhdiotconnect -servername "minwinpc" -password "p@ssw0rd"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdiotconnectfirstrp3()
{
    hhdiotconnect -servername "firstrp3" -password "p@ssw0rd"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdiotmountdrivefirstrp3()
{
    Write-Host "
`$servername = `"firstrp2`"
`$password = `"password`"
`$passwordEnc = ConvertTo-SecureString `$password -AsPlainText -Force
`$cred = New-Object System.Management.Automation.PSCredential(`"`$servername\administrator`", `$passwordEnc)
New-PSDrive -Name iot -PSProvider FileSystem -Root \\`$servername\c$ -Credential `$cred
    ";
}



<#
.SYNOPSIS
.PARAMETER process
.PARAMETER prefix
.PARAMETER strArray
.EXAMPLE
#>
function mycomplexfunc
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.Diagnostics.Process]
        $process,

        [System.String]
        $prefix,

        [System.String[]]
        $strArray
    )
    begin
    {
    }
    process
    {
        $obj = New-Object -typename PSObject

        $obj | Add-Member -MemberType NoteProperty -Name prefix -Value $prefix
        $obj | Add-Member -MemberType NoteProperty -Name ProcessName -Value $process.Name
        $obj | Add-Member -MemberType NoteProperty -Name ProcessId -Value $process.Id

        Write-Host ("strArray.Length : " + $strArray.Length)

        if ($strArray.Length -gt 0) 
        {
            $rand = New-Object -TypeName System.Random
            $idx = $rand.Next($strArray.Length)

            Write-Host ("idx : " + $idx)

            $randValue = $strArray[$idx]

            Write-Host ("randValue : " + $randValue)

            $obj | Add-Member -MemberType NoteProperty -Name randValue -Value $randValue
        }

        Write-Output $obj
    }
}



<#
.SYNOPSIS
.PARAMETER dbObj
.EXAMPLE
    PS C:\temp> Get-AzureSqlDatabaseServer | Get-AzureSqlDatabase | hhdazuresqldatabasedetail
#>
function hhdazuresqldatabasedetail
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [Microsoft.WindowsAzure.Commands.SqlDatabase.Services.Server.Database]
        $dbObj
    )
    begin
    {
    }
    process
    {
        $obj = New-Object -typename PSObject
        $dbType = [Microsoft.WindowsAzure.Commands.SqlDatabase.Services.Server.Database]
        $methodList = $dbType.GetMethods() | where { $_.Name -like "get_*" }

        foreach ($method in $methodList) 
        {
            $name = $method.Name.TrimStart("get_")
            $value = $method.Invoke($dbObj, $null)

            if ([string]::IsNullOrWhiteSpace($value))
            {
                continue
            }



            $obj | Add-Member -MemberType NoteProperty -Name $name -Value $value
        }

        #pyx1rbr0s0.database.windows.net
        #Server=tcp:pyx1rbr0s0.database.windows.net,1433;Data Source=pyx1rbr0s0.database.windows.net;Initial Catalog=hhdyidbot;Persist Security Info=False;User ID={your_username};Password={your_password};Pooling=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;

        $serverName = $dbObj.Context.ServerName
        $dbName = $dbObj.Name
        $obj | Add-Member -MemberType NoteProperty -Name ServerAddress -Value "$serverName.database.windows.net"
        $obj | Add-Member -MemberType NoteProperty -Name ConnectionString -Value "Server=tcp:$serverName.database.windows.net,1433;Data Source=$serverName.database.windows.net;Initial Catalog=$dbName;Persist Security Info=False;User ID={your_username};Password={your_password};Pooling=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
        Write-Output $obj
    }
}



<#
.SYNOPSIS
.PARAMETER var
.EXAMPLE
#>
function hhdnetworkgetpubip
{
    $myPubIp = (Invoke-WebRequest -Uri http://icanhazip.com).Content
    return $myPubIp   
}




<#
.SYNOPSIS
.PARAMETER var
.EXAMPLE
#>
function hhdls($dir, $path)
{
    $result = ls $dir -Recurse -Force | where FullName -Like $path
    Write-Host $result.FullName
}



<#
.SYNOPSIS
.PARAMETER var
.EXAMPLE
#>
function hhdwmigetprogram
{
    gwmi -Class win32_product
}



<#
.SYNOPSIS
.PARAMETER dllpath
.EXAMPLE
    C:\hhdcommand\PsDev\HPsUtils\bin\Debug\HPsUtils.dll
#>
function hhdmoduleloadfromdll($dllpath)
{
    if (Test-Path $dllpath -eq $false)
    {
        Write-Host "no file ${dllpath} ..."
        return
    }

    Add-Type -Path $dllpath -Verbose
    Import-Module $dllpath -Verbose
}



<#
.SYNOPSIS
.PARAMETER dllpath
.EXAMPLE
#>
function hhdnugetrestore($slnfile)
{
    nuget restore -SolutionDirectory $slnfile -PackagesDirectory packages
}






















Write-Host "update profile.ps1 ..."

if (Test-Path C:\hhdcommand\PsDev\PsScripts\profile.ps1)
{
    Write-Host "copy profile.ps1 ..."
    cp -Force C:\hhdcommand\PsDev\PsScripts\profile.ps1 "C:\Windows\System32\WindowsPowerShell\v1.0"
}
else
{
    Write-Host "skip profile.ps1 ..."
}