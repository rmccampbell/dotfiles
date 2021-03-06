# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Import-Module posh-git
if ($env:WT_SESSION) {
    Import-Module oh-my-posh
    # Agnoster Paradox Operator PowerlinePlus Sorin Honukai Powerlevel9k
    Set-Theme Paradox
}

# Customize Powershell
Update-FormatData -PrependPath $HOME\Documents\PowerShell\CommandInfo.format.ps1xml
Update-FormatData -PrependPath $HOME\Documents\PowerShell\FileSystem.format.ps1xml

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
        if ($var) {
            Set-Location $var.Value
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
$D = "$HOME\Documents"
$DL = "$HOME\Downloads"
$GH = "$HOME\Documents\git"
$H = "$HOME"
$M = "$HOME\Music"
$P = "$HOME\Documents\Python"
$PP = "$HOME\Documents\Python\PythonProjects"
$PB = "$HOME\Documents\Python\bin"
$PC = "$HOME\Pictures"
$PSP = "$HOME\AppData\Local\Programs\Python\Python39\Lib\site-packages"
$V = "$HOME\Videos"
