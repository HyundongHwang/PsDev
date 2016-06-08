Write-Host "�ȳ��ϼ���" $env:USERNAME"��"



$oldPath = Get-Content Env:\Path

Set-Item Env:\Path "
    $oldPath;
    c:\Program Files (x86)\Git\bin\;
"

Write-Host "cat Env Path"
cat Env:\Path



$OutputEncoding = New-Object -TypeName System.Text.UTF8Encoding
Write-Host "$OutputEncoding"
$OutputEncoding




# $DebugPreference = "continue"



Write-Host "Set-ExecutionPolicy Bypass -Scope Process -Force"
Set-ExecutionPolicy Bypass -Scope Process -Force




Write-Host "Import-AzurePublishSettingsFile"
Import-AzurePublishSettingsFile ~\*.publishsettings





##############################################################################################
# update custom profile.ps1, dlls ... 
##############################################################################################

Write-Host "update custom profile.ps1, dlls ... "

if (Test-Path C:\hhdcommand\PsDev\PsScripts\profile.ps1)
{
    Write-Host "profile.ps1 ������Ʈ ..."
    cp -Force C:\hhdcommand\PsDev\PsScripts\profile.ps1 $PSHOME
}
else
{
    Write-Host "profile.ps1 ������Ʈ ��ŵ ..."
}

if (Test-Path "C:\hhdcommand\PsDev\HPsUtils\bin\Debug\HPsUtils.dll")
{
    Write-Host "HPsUtils.dll ������Ʈ ..."

    Try
    {
        cp -Force -Recurse C:\hhdcommand\PsDev\HPsUtils\bin\Debug\* $PSHOME
    }
    Catch
    {
        Write-Warning "cp HPsUtils.dll ����!!! ex : "
        Write-Warning $_.Exception
    }

    Add-Type -Path "$PSHOME\HPsUtils.dll"
    Import-Module "$PSHOME\HPsUtils.dll"
}
else
{
    Write-Host "HPsUtils.dll ������Ʈ ��ŵ ..."
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
# simple functions ... 
##############################################################################################
function adblogcatmono
{
    adb logcat -s mono-stdout:v
}

function lsforce
{
    Get-ChildItem -Force
}

function cdtemp
{
    cd c:\temp
}

function cdproject
{
    cd c:\project
}

function sublimeprofileps1
{
    sublime c:\hhdcommand\PsDev\PsScripts\profile.ps1
}

function catprofileps1
{
    cat c:\hhdcommand\PsDev\PsScripts\profile.ps1
}

function cd2($keyword)
{
    cd *$keyword*
}

function ps2()
{
    ps | sort WS -Descending | select Id, Name, @{l="WS(M)"; e={[int]($_.WS / 1024 / 1024)}}, Path -First 10 | ft -AutoSize -Wrap
}

function gitgraph
{
    git log --pretty=format:"%h %s - %an %ar" --graph
}

function catlog($path)
{
    cat -Wait $path
}

function rmforce($path)
{
    rm -Recurse -Force $path
}

function vspsdev()
{
    Start-Process devenv.exe -Verb runAs -ArgumentList c:\hhdcommand\PsDev\PsDev.sln
}

function azurecurrent()
{
    Write-Host "Get-AzureSubscription"
    pause
    Get-AzureSubscription



    Write-Host "Get-AzureWebsite"
    pause
    Get-AzureWebsite



    Write-Host "Get-AzureSqlDatabaseServer"
    pause
    Get-AzureSqlDatabaseServer

    Write-Host "Get-AzureSqlDatabaseServer | Get-AzureSqlDatabase"
    pause
    Get-AzureSqlDatabaseServer | Get-AzureSqlDatabase



    Write-Host "Get-AzureStorageAccount"
    pause
    Get-AzureStorageAccount

    Write-Host "Get-AzureStorageAccount | Get-AzureStorageContainer"
    pause
    Get-AzureStorageAccount | Get-AzureStorageContainer

    Write-Host "Get-AzureStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob"
    pause
    Get-AzureStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob
}

<#
.SYNOPSIS
    rm -Recurse -Force $path
.PARAMETER path
    ����, ���丮 ���
.EXAMPLE
    rmforce aaa
#>
function rmforce($path)
{
    rm -Recurse -Force $path
}

<#
.SYNOPSIS
    kill -Name *powershell*
    �Ŀ��� ���� ���μ����� ��� �׿��� hpsutils.dll�� �� �����ǵ��� �Ѵ�.
.EXAMPLE
    killpowershell
#>
function killpowershell()
{
    kill -Name *powershell*
}



<#
.SYNOPSIS
.EXAMPLE
    connectiotdevice -servername "firstrp2" -password "password"
#>
function connectiotdevice($servername, $password)
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
    connectiotdevicefirstrp2
#>
function connectiotdevicefirstrp2()
{
    connectiotdevice -servername "firstrp2" -password "p@ssw0rd"
}



<#
.SYNOPSIS
.EXAMPLE
    connectiotdevicesecondrp2
#>
function connectiotdevicesecondrp2()
{
    connectiotdevice -servername "secondrp2" -password "p@ssw0rd"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function mountiotdrivefirstrp2()
{
    Write-Host "
`$servername = `"firstrp2`"
`$password = `"password`"
`$passwordEnc = ConvertTo-SecureString `$password -AsPlainText -Force
`$cred = New-Object System.Management.Automation.PSCredential(`"`$servername\administrator`", `$passwordEnc)
New-PSDrive -Name iot -PSProvider FileSystem -Root \\`$servername\c$ -Credential `$cred
    ";
}



##############################################################################################
# complex functions ... 
##############################################################################################

<#
.SYNOPSIS
    mycomplexfunc ���ž���.
.PARAMETER process
    ���μ��� ��ü
.PARAMETER prefix
    �Ϲ� ���ڿ� ��ü
.PARAMETER strArray
    ���ڿ� �迭
.EXAMPLE
    PS C:\temp> ps | where {$_.Name -eq "chrome"} | mycomplexfunc -prefix "�����Ƚ�" -strArray @("��", "��", "��")
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��

    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 1
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 1
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 2
    �����: randValue : ��
    �����: strArray.Length : 3
    �����: idx : 0
    �����: randValue : ��
    prefix   ProcessName ProcessId randValue
    ------   ----------- --------- ---------
    �����Ƚ� chrome           8924 ��
    �����Ƚ� chrome          12980 ��
    �����Ƚ� chrome          13816 ��
    �����Ƚ� chrome          14596 ��
    �����Ƚ� chrome          16776 ��
    �����Ƚ� chrome          18068 ��
    �����Ƚ� chrome          18172 ��
    �����Ƚ� chrome          18404 ��
    �����Ƚ� chrome          20244 ��
    �����Ƚ� chrome          20324 ��
    �����Ƚ� chrome          21784 ��
    �����Ƚ� chrome          22216 ��
    �����Ƚ� chrome          22412 ��
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