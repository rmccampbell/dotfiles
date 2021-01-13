# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Import-Module posh-git
Import-Module oh-my-posh
if ($env:WT_SESSION) {
    Set-Theme PowerlinePlus
}

# Customize Powershell
Update-FormatData -PrependPath C:\Users\Ryan\Documents\PowerShell\CommandInfo.format.ps1xml
Update-FormatData -PrependPath C:\Users\Ryan\Documents\PowerShell\FileSystem.format.ps1xml

if ($PSVersionTable.PSEdition -eq "Desktop") {
    # https://stackoverflow.com/questions/40098771/changing-powershells-default-output-encoding-to-utf-8
    $PSDefaultParameterValues['*:Encoding'] = 'utf8'
}

# Aliases
New-Alias which Get-Command
# Remove-Alias -Force where
# New-Alias where Get-Command
New-Alias grep Select-String
New-Alias time Measure-Command
New-Alias sel Select-Object
New-Alias jobs Get-Job
New-Alias psh powershell.exe
New-Alias ipy ipython.exe
New-Alias py38 "C:\Program Files\Python38\python.exe"
New-Alias ipy38 "C:\Program Files\Python38\Scripts\ipython.exe"
New-Alias pip38 "C:\Program Files\Python38\Scripts\pip.exe"
New-Alias pdn "C:\Program Files\paint.net\PaintDotNet.exe"
New-Alias vlc "C:\Program Files\VideoLAN\VLC\vlc.exe"
New-Alias v video.pyw
New-Alias ydl youtube-dl

# Functions
function l { Get-ChildItem @args | Format-Wide -AutoSize }
function gitp { git --no-pager @args }
function gs { git status @args }
function gd { git diff @args }
function gds { git diff --cached @args }
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
function wcd($c) { Set-Location (Split-Path (whichp $c)) }
function up { Set-Location .. }
function assoc { cmd /c assoc @args }
function ftype { cmd /c ftype @args }
function chromei { chrome --incognito @args }
function Get-Property($prop, [Parameter(ValueFromPipeline)] $obj) {
    Process {
        $obj | Select-Object -ExpandProperty $prop
    }
}
New-Alias p Get-Property
function Cd-Variable($v) {
    Set-Location $v -ErrorAction Ignore
    if (!$?) {
        $var = Get-Variable $v -Scope Global -ErrorAction Ignore
        if (!$?) {
            $var = Get-Item Env:$v
        }
        Set-Location $var.Value
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

$_complete_cmd = { param($commandName, $parameterName, $stringMatch) Get-Command $stringMatch* }
Register-ArgumentCompleter -CommandName whichp -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName def -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName wcat -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName wcd -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName wless -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName wedit -ParameterName c -ScriptBlock $_complete_cmd
Register-ArgumentCompleter -CommandName Less-Help -ParameterName c -ScriptBlock $_complete_cmd

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
Set-PSReadlineKeyHandler -Chord Ctrl+z -Function Undo
Set-PSReadlineKeyHandler -Chord Ctrl+Z -Function Redo
Set-PSReadlineKeyHandler -Chord Ctrl+/ -Function Undo
Set-PSReadlineKeyHandler -Chord Ctrl+\ -Function Redo
Set-PSReadlineKeyHandler -Chord Alt+F4 -Function ViExit

# Path shortcuts
$BF = "C:\Users\Ryan\Documents\coding\bf"
$C = "C:\Users\Ryan\Documents\coding"
$CG = "C:\Users\Ryan\Documents\Python\challenges\codegolf"
$D = "C:\Users\Ryan\Documents"
$DL = "C:\Users\Ryan\Downloads"
$GGJ = "C:\Users\Ryan\Documents\SGD\GGJ-2020-ACE"
$GH = "C:\Users\Ryan\Documents\git"
$GR = "C:\Users\Ryan\Documents\UVa\Spring_2016\Graphics"
$H = "C:\Users\Ryan"
$LGL = "C:\Users\Ryan\Documents\Visual Studio 2019\Projects\LearnOpenGL"
$M = "C:\Users\Ryan\Music"
$MIDI = "C:\Users\Ryan\Music\Midi"
$OSC = "C:\Users\Ryan\Documents\UVa\Fall_2017\OS"
$P = "C:\Users\Ryan\Documents\Python"
$PP = "C:\Users\Ryan\Documents\Python\PythonProjects"
$PA = "C:\Users\Ryan\Documents\UVa\Spring_2017\Parallel"
$PB = "C:\Users\Ryan\Documents\Python\bin"
$PC = "C:\Users\Ryan\Pictures"
$PCH = "C:\Users\Ryan\Documents\Python\challenges\pythonchallenge"
$PDR = "C:\Users\Ryan\Documents\UVa\Fall_2015\cs2150"
$PL = "C:\Users\Ryan\Documents\UVa\Spring_2017\ProgLang"
$PSP = "C:\Users\Ryan\AppData\Local\Programs\Python\Python39\Lib\site-packages"
$S = "C:\shared"
$SGD = "C:\Users\Ryan\Documents\SGD"
$UVA = "C:\Users\Ryan\Documents\UVa"
$V = "C:\Users\Ryan\Videos"
$VS = "C:\Users\Ryan\Documents\Visual Studio 2019\Projects"
$Y = "C:\Users\Ryan\Videos\youtube"
