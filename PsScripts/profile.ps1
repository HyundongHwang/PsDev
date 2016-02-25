Write-Host "안녕하세요" $env:USERNAME"님"
$oldPath = Get-Content Env:\Path

Set-Item Env:\Path "
    $oldPath;
    c:\Program Files (x86)\Git\bin\;
"

$OutputEncoding = New-Object -TypeName System.Text.UTF8Encoding
$DebugPreference = "continue"
Set-ExecutionPolicy Unrestricted -Scope CurrentUser



##############################################################################################
# update custom profile.ps1, dlls ... 
##############################################################################################
if (Test-Path C:\hhdcommand\PsDev\PsScripts\profile.ps1)
{
    Write-Debug "profile.ps1 업데이트 ..."
    cp -Force C:\hhdcommand\PsDev\PsScripts\profile.ps1 $PSHOME
}
else
{
    Write-Debug "profile.ps1 업데이트 스킵 ..."
}

if (Test-Path "C:\hhdcommand\PsDev\HPsUtils\bin\Debug\HPsUtils.dll")
{
    Write-Debug "HPsUtils.dll 업데이트 ..."

    Try
    {
        cp -Force -Recurse C:\hhdcommand\PsDev\HPsUtils\bin\Debug\* $PSHOME
    }
    Catch
    {
        Write-Warning "cp HPsUtils.dll 실패!!! ex : "
        Write-Warning $_.Exception
    }

    Add-Type -Path "$PSHOME\HPsUtils.dll"
    Import-Module "$PSHOME\HPsUtils.dll"
}
else
{
    Write-Debug "HPsUtils.dll 업데이트 스킵 ..."
}


##############################################################################################
# alias ... 
##############################################################################################
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
function lsforce
{
    Get-ChildItem -Force
}

function cdpsscripts
{
    cd c:\hhdcommand\PsScripts\
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
    sublime c:\hhdcommand\PsScripts\profile.ps1
}

function catprofileps1
{
    cat c:\hhdcommand\PsScripts\profile.ps1
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

<#
.SYNOPSIS
    rm -Recurse -Force $path
.PARAMETER path
    파일, 디렉토리 경로
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
    파워쉘 관련 프로세스를 모두 죽여서 hpsutils.dll이 잘 배포되도록 한다.
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
    Write-Debug "start winrm service ..."
    net start winrm

    Write-Debug "add TrustedHosts ..."
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $servername

    $passwordEnc = ConvertTo-SecureString "password" -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential("$servername\administrator", $passwordEnc)

    Write-Debug "enter pssession ..."
    Enter-PSSession -ComputerName $servername -Credential $cred
}



<#
.SYNOPSIS
.EXAMPLE
    connectiotdevicefirstrp2
#>
function connectiotdevicefirstrp2()
{
    connectiotdevice -servername "firstrp2" -password "password"
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
`$passwordEnc = ConvertTo-SecureString $password -AsPlainText -Force
`$cred = New-Object System.Management.Automation.PSCredential(`"`$servername\administrator`", `$passwordEnc)
New-PSDrive -Name iot -PSProvider FileSystem -Root \\`$servername\c$ -Credential `$cred
    ";
}



##############################################################################################
# complex functions ... 
##############################################################################################

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

        Write-Debug ("strArray.Length : " + $strArray.Length)

        if ($strArray.Length -gt 0) 
        {
            $rand = New-Object -TypeName System.Random
            $idx = $rand.Next($strArray.Length)

            Write-Debug ("idx : " + $idx)

            $randValue = $strArray[$idx]

            Write-Debug ("randValue : " + $randValue)

            $obj | Add-Member -MemberType NoteProperty -Name randValue -Value $randValue
        }

        Write-Output $obj
    }
}