##############################################################################################
# initial configuration ... 
##############################################################################################

Write-Host "hello $env:USERNAME, welcome ..."



Write-Host "configure path ..."

$oldPath = Get-Content Env:\Path

Set-Item Env:\Path "
    $oldPath;
    c:\Program Files (x86)\Git\bin\;
"

cat Env:\Path



Write-Host "configure output encoding as utf8 ..."
$OutputEncoding = New-Object -TypeName System.Text.UTF8Encoding
Write-Host "$OutputEncoding"
$OutputEncoding




# $DebugPreference = "continue"



Write-Host "configure execution policy ..."
Set-ExecutionPolicy Bypass -Scope Process -Force



Write-Host "update custom profile.ps1, dlls ... "

if (Test-Path C:\hhdcommand\PsDev\PsScripts\profile.ps1)
{
    Write-Host "update profile.ps1 ..."
    cp -Force C:\hhdcommand\PsDev\PsScripts\profile.ps1 $PSHOME
}
else
{
    Write-Host "skip profile.ps1 ..."
}

if (Test-Path "C:\hhdcommand\PsDev\HPsUtils\bin\Debug\HPsUtils.dll")
{
    Write-Host "update HPsUtils.dll ..."

    Try
    {
        cp -Force -Recurse C:\hhdcommand\PsDev\HPsUtils\bin\Debug\* $PSHOME
    }
    Catch
    {
        Write-Host "failed to copy HPsUtils.dll !!! ex : "
        Write-Host $_.Exception
    }

    Add-Type -Path "$PSHOME\HPsUtils.dll"
    Import-Module "$PSHOME\HPsUtils.dll"
}
else
{
    Write-Host "skip HPsUtils.dll ..."
}



Write-Host "azure login ..."
Import-AzurePublishSettingsFile ~\*.publishsettings



if($pwd -like "*WINDOWS\System32*")
{
    if(!(Test-Path \temp))
    {
        mkdir \temp
    }

    Write-Host "change directory to temp ..."
    cd \temp
}






##############################################################################################
# alias ... 
##############################################################################################

Write-Host "alias ... "

Set-Alias vim "c:\hhdcommand\vim74\vim.exe"
Set-Alias sublime "c:\hhdcommand\Sublime Text 2.0.2\sublime.exe"
Set-Alias open "C:\Windows\SysWOW64\explorer.exe"
Set-Alias vs2013 "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"
Set-Alias vs2015 "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe"
Set-Alias blend2013 "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\blend.exe"
Set-Alias blend2015 "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\blend.exe"
Set-Alias honeyview "C:\Program Files\Honeyview\Honeyview.exe"
Set-Alias sqlite3 "c:\hhdcommand\sqlite\sqlite3.exe"






##############################################################################################
# functions ... 
##############################################################################################



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-ls
{
    ls -Force
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-cd-temp
{
    cd c:\temp
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-cd-project
{
    cd c:\project
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-sublime-profile-ps1
{
    sublime c:\hhdcommand\PsDev\PsScripts\profile.ps1
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-cat-profile-ps1
{
    cat c:\hhdcommand\PsDev\PsScripts\profile.ps1
}



<#
.SYNOPSIS
.EXAMPLE
    PS C:\> hhd-cd win
    PS C:\Windows>
#>
function hhd-cd($keyword)
{
    cd *$keyword*
}



<#
.SYNOPSIS
.EXAMPLE
    PS C:\> hhd-ps

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
function hhd-ps()
{
    ps | sort WS -Descending | select Id, Name, @{l="WS(M)"; e={[int]($_.WS / 1024 / 1024)}}, Path -First 10 | ft -AutoSize -Wrap
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-graph
{
    git log --pretty=format:"%h %s - %an %ar" --graph
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-cat-log($path)
{
    cat -Wait $path
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-vs-psdev()
{
    Start-Process devenv.exe -Verb runAs -ArgumentList c:\hhdcommand\PsDev\PsDev.sln
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-adb-logcat-mono
{
    adb logcat -s mono-stdout:v
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-azure-current()
{
    Write-Host "azure subscription check ..."
    pause
    Get-AzureSubscription



    Write-Host "azure website check ..."
    pause
    Get-AzureWebsite



    Write-Host "azure sql database check ..."
    pause
    Get-AzureSqlDatabaseServer | Get-AzureSqlDatabase | hhd-azure-sql-database-detail



    Write-Host "azure storage account check ..."
    pause
    Get-AzureStorageAccount

    Write-Host "azure storage blob check ..."
    pause
    Get-AzureStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob
}



<#
.SYNOPSIS
.PARAMETER path
.EXAMPLE
#>
function hhd-rm($path)
{
    rm -Recurse -Force $path
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-kill-about-powershell()
{
    kill -Name *powershell*
}



<#
.SYNOPSIS
.EXAMPLE
    hhd-iot-connect -servername "minwinpc" -password "p@ssw0rd"
#>
function hhd-iot-connect($servername, $password)
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
function hhd-iot-connect-minwinpc()
{
    hhd-iot-connect -servername "minwinpc" -password "p@ssw0rd"
}




<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-connect-iot-firstrp3()
{
    hhd-iot-connect -servername "firstrp3" -password "p@ssw0rd"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-mount-iot-drive-firstrp3()
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
    mycomplexfunc 별거없다.
.PARAMETER process
    프로세스 객체
.PARAMETER prefix
    일반 문자열 객체
.PARAMETER strArray
    문자열 배열
.EXAMPLE
    PS C:\temp> ps | where {$_.Name -eq "chrome"} | mycomplexfunc -prefix "프레픽스" -strArray @("일", "이", "삼")
    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 삼

    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 삼
    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 삼
    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 삼
    디버그: strArray.Length : 3
    디버그: idx : 1
    디버그: randValue : 이
    디버그: strArray.Length : 3
    디버그: idx : 1
    디버그: randValue : 이
    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 삼
    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 삼
    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 삼
    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 삼
    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 삼
    디버그: strArray.Length : 3
    디버그: idx : 2
    디버그: randValue : 삼
    디버그: strArray.Length : 3
    디버그: idx : 0
    디버그: randValue : 일
    prefix   ProcessName ProcessId randValue
    ------   ----------- --------- ---------
    프레픽스 chrome           8924 삼
    프레픽스 chrome          12980 삼
    프레픽스 chrome          13816 삼
    프레픽스 chrome          14596 삼
    프레픽스 chrome          16776 이
    프레픽스 chrome          18068 이
    프레픽스 chrome          18172 삼
    프레픽스 chrome          18404 삼
    프레픽스 chrome          20244 삼
    프레픽스 chrome          20324 삼
    프레픽스 chrome          21784 삼
    프레픽스 chrome          22216 삼
    프레픽스 chrome          22412 일
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
    azure sql server database의 디테일한 정보 리턴
.PARAMETER dbObj
    azure sql server database 객체 
.EXAMPLE
    PS C:\temp> Get-AzureSqlDatabaseServer | Get-AzureSqlDatabase | hhd-azure-sql-database-detail
#>
function hhd-azure-sql-database-detail
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






Write-Host "list hhd commands functions ..."
gcm hhd-* | ft