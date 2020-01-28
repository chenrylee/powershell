function New-Shortcut {
    <#
    .SYNOPSIS
        Create a new shortcut.
    .DESCRIPTION
        Shortcuts are everywhere on a Windows, but it's not easy to operate shortcuts with PowerShell.
    .PARAMETER Name
        The shortcut name, by default, it's same with the target.
    .PARAMETER Path
        The path you save the shortcut, by default, it's your desktop.
    .PARAMETER Target
        Where the shortcut points to.
    .PARAMETER Arguments
        Startup arguments of the target.
    .PARAMETER Comment
        The description of this shortcut.
    .LINK
        https://github.com/chenrylee
    .NOTES
        Author: Chenry Lee
        Version: 20200128
    #>
    [CmdletBinding()]
    param (
        [string]$Name,
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$Target,
        [string]$Arguments,
        [string]$Comment
    )

    if (!(Test-Path $Target)) {
        Write-Error -Message "Invalid target path."
    }

    if ([string]::IsNullOrEmpty($Path)) {
        $Path = "$env:USERPROFILE\Desktop"
    }

    if ([string]::IsNullOrEmpty($Name)) {
        $Name = (Get-ChildItem $Target).BaseName + ".lnk"
    }

    $Shortcut = $Path + '\' + $Name

    $objShell = New-Object -ComObject WScript.Shell
    $myShortcut = $objShell.CreateShortcut($Shortcut)
    $myShortcut.TargetPath = $Target
    $myShortcut.Arguments = $Arguments
    $myShortcut.WorkingDirectory = Split-Path $Target
    $myShortcut.Description = $Comment
    $myShortcut.Save()
}
