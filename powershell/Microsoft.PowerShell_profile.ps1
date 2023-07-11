# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Import-Module posh-git
Import-Module posh-cargo
Import-Module 'C:\vcpkg\scripts\posh-vcpkg'

# if ($env:WT_SESSION -or $env:TERM_PROGRAM -eq "vscode") {
# Import-Module oh-my-posh
# Agnoster Paradox Operator PowerlinePlus Sorin Honukai Powerlevel9k
# Set-Theme Paradox
$env:POSH_GIT_ENABLED = $true
oh-my-posh init pwsh --config "$HOME\Documents\PowerShell\themes\paradox-custom.omp.json" | Invoke-Expression
# }

$PSNativeCommandArgumentPassing = "Windows"
$MaximumHistoryCount = 32767

# Customize Powershell
Update-FormatData -PrependPath $HOME\Documents\PowerShell\CommandInfo.format.ps1xml
# Update-FormatData -PrependPath $HOME\Documents\PowerShell\FileSystem.format.ps1xml

if ($PSVersionTable.PSEdition -eq "Desktop") {
    # https://stackoverflow.com/questions/40098771/changing-powershells-default-output-encoding-to-utf-8
    $PSDefaultParameterValues["*:Encoding"] = "utf8"
}

# Aliases
New-Alias ll Get-ChildItem
New-Alias lsd Get-Item
New-Alias lld Get-Item
New-Alias which Get-Command
# Remove-Alias -Force where
# New-Alias where Get-Command
# New-Alias grep Select-String
# Remove-Alias -Force diff
Remove-Item -Force alias:diff
New-Alias time Measure-Command
New-Alias dirname Split-Path
function basename { Split-Path -Leaf @args }
New-Alias sel Select-Object
New-Alias jobs Get-Job
New-Alias psh powershell.exe
New-Alias ipy ipython.exe
New-Alias pdn "C:\Program Files\paint.net\PaintDotNet.exe"
New-Alias vlc "C:\Program Files\VideoLAN\VLC\vlc.exe"
New-Alias v video.pyw
New-Alias ydl yt-dlp

# Functions
function l { Get-ChildItem @args | Format-Wide -AutoSize }
function gitp { git --no-pager @args }
function gs { git status @args }
Remove-Item -Force alias:gl
function gl { git log @args }
function gd { git diff @args }
function gdp { git --no-pager diff @args }
function gds { git diff --cached @args }
function gdsp { git --no-pager diff --cached @args }
function ga { git add -A @args }
function whichp($c) { (Get-Command $c).Path }
function def($c) { (Get-Command $c).Definition }
function wcat($c) {
    $c = Get-Command $c -ErrorAction Stop
    if ($c.Path) {
        Get-Content $c.Path
    } else {
        $c.Definition
    }
}
function wless($c) {
    $c = Get-Command $c -ErrorAction Stop
    if ($c.Path) {
        less $c.Path
    } else {
        $c.Definition | less
    }
}
function wedit($c) { code (whichp $c) }
function wcode($c) { code (whichp $c) }
function wsubl($c) { subl (whichp $c) }
function wcd($c) { Set-Location (Split-Path (whichp $c)) }
New-Alias whichcd wcd
function wdo($do, $c) {
    if ($MyInvocation.ExpectingInput) {
        $input | &$do (whichp $c) @args
    } else {
        &$do (whichp $c) @args
    }
}
New-Alias whichdo wdo
function wpy($c) {
    if ($MyInvocation.ExpectingInput) {
        $input | py (whichp $c) @args
    } else {
        py (whichp $c) @args
    }
}
New-Alias wpyw whichpyw.bat

function up { Set-Location .. }
function upup { Set-Location ..\.. }
New-Alias .. up
New-Alias ... upup
function cmdc { cmd /c @args }
function startcmd { Start-Process cmd (,"/c" + $args) }
function assoc { cmd /c assoc @args }
function ftype { cmd /c ftype @args }
function mklink { cmd /c mklink @args }
function chromei { chrome --incognito @args }
New-Alias ichrome chromei
function mdless { mdcat -p @args }
function Get-Property($prop) {
    $input | Select-Object -ExpandProperty $prop
}
New-Alias p Get-Property

function _cdvar_complete($commandName, $parameterName, $wordToComplete) {
    $w = $wordToComplete
    $res = Get-ChildItem $w* -ErrorAction Ignore
    if ($res) {
        # Default completion
    } else {
        if ($w -match "[\\/]") {
            $v, $p = $w -split "[\\/]", 2
            $var = Get-Variable $v -Scope Global -ErrorAction Ignore
            if (!$?) {
                $var = Get-Item Env:$v
            }
            if ($var -and $var.Value -is [string]) {
                Get-ChildItem -Directory "$($var.Value)\$p*" |
                    ForEach-Object { if ($_ -match " ") { "'$_\'" } else { "$_\" } }
            }
        } else {
            @((Get-Item Env:$w*).Name) + @((Get-Variable -Scope Global $w*).Name) |
                Where-Object { $_ -ne $null }
        }
    }
}

function Cd-Variable([ArgumentCompleter({ _cdvar_complete @args })]$p) {
    Set-Location $p -ErrorAction Ignore
    if (!$?) {
        $v, $p = $p -split "[\\/]", 2
        $var = Get-Variable $v -Scope Global -ErrorAction Ignore
        if (!$?) {
            $var = Get-Item Env:$v
        }
        if ($var) {
            Set-Location $var.Value
            if ($p) {
                Set-Location $p
            }
        }
    }
}
New-Alias c Cd-Variable

function Less-Help($c) {
    $cmd = Get-Command $c -ErrorAction Stop
    if ($cmd.CommandType -eq "Alias") {
        $cmd = $cmd.ResolvedCommand
    }
    if ($cmd.CommandType -eq "Application") {
        & $cmd --help 2>&1 | less
    }
    else {
        help $cmd | less
    }
}
New-Alias lh Less-Help
function jql {
    if ($MyInvocation.ExpectingInput) {
        $input | jq -C @args | less -R
    } else {
        jq -C @args | less -R
    }
}

$_complete_cmd = { param($commandName, $parameterName, $wordToComplete) Get-Command $wordToComplete* }
Register-ArgumentCompleter -CommandName whichp -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName def -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName wcat -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName wless -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName wedit -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName wcd -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName wdo -ParameterName do -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName wdo -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName Less-Help -ParameterName c -ScriptBlock $_complete_cmd

$_pycompleter = { param($wordToComplete, $commandAst, $cursorPosition) (pycompleter $wordToComplete).split() }
Register-ArgumentCompleter -CommandName ppy -Native -ScriptBlock $_pycompleter

# Key bindings
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Chord Ctrl+v -Function Paste
Set-PSReadlineKeyHandler -Chord Ctrl+x -Function Cut
Set-PSReadlineKeyHandler -Chord Ctrl+Backspace -Function BackwardKillWord
Set-PSReadlineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadlineKeyHandler -Chord Ctrl+RightArrow -Function NextWord
Set-PSReadlineKeyHandler -Chord Shift+Ctrl+LeftArrow -Function SelectBackwardWord
Set-PSReadlineKeyHandler -Chord Shift+Ctrl+RightArrow -Function SelectNextWord
Set-PSReadlineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Chord DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Chord Shift+Tab -Function TabCompleteNext
Set-PSReadlineKeyHandler -Chord Ctrl+Tab -Function TabCompletePrevious
Set-PSReadlineKeyHandler -Chord Ctrl+Shift+Tab -Function TabCompletePrevious
Set-PSReadlineKeyHandler -Chord Ctrl+z -Function Undo
Set-PSReadlineKeyHandler -Chord Ctrl+Z -Function Redo
Set-PSReadlineKeyHandler -Chord Ctrl+/ -Function Undo
Set-PSReadlineKeyHandler -Chord Ctrl+\ -Function Redo
Set-PSReadlineKeyHandler -Chord Alt+F4 -Function ViExit

# Path shortcuts
$C = "$HOME\Documents\coding"
$D = "$HOME\Documents"
$DL = "$HOME\Downloads"
$GH = "$HOME\Documents\git"
$H = "$HOME"
$M = "$HOME\Music"
$P = "$HOME\Documents\Python"
$PB = "$HOME\Documents\Python\bin"
$PC = "$HOME\Pictures"
$PP = "$HOME\Documents\Python\PythonProjects"
$PSP = "$HOME\AppData\Local\Programs\Python\Python39\Lib\site-packages"
$V = "$HOME\Videos"
