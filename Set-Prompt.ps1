Function Prompt()
{
    switch ($PSPromptMode)
    {
        'Cmd'
        {
          "$($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
        }
        'Dollar'
        {
            "[$($env:username)@$($env:computername) $($executionContext.SessionState.Path.CurrentLocation)$(']$ ' * ($nestedPromptLevel + 1))"
        }
        'Pound'
        {
            "[$($env:username)@$($env:computername) $($executionContext.SessionState.Path.CurrentLocation)$(']# ' * ($nestedPromptLevel + 1))"
        }
 
        'None'
        {
          ' '
        }
        'Simple'
        {
         'PS>'
        }
        Default
        {
         "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
        }
    }
}
 
<#
.Synopsis
   Set console promt style
.DESCRIPTION
   Set console promt style, 6 styles are supported:  Normal, Cmd, Pound, Dollar, Simple, None
.Example
    Set-Prompt -Mode Pound
    Set the prompt style to Pound style:
    [root@localhost C:\Users\username]# 
.Example
    Set-Prompt -Mode Dollar
    Set the prompt style to Dollar style:
    [root@localhost C:\Users\username]$ 
#>
Function Set-Prompt
{
    param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('Normal','Cmd','Dollar','Pound','Simple', 'None',IgnoreCase = $true)]
    $Mode
    )
    $varPSPromptMode = (Get-Variable 'PSPromptMode'  -ea SilentlyContinue)
    # Create variable if not exist
    if ( $varPSPromptMode -eq $null)
    {
        New-Variable -Name 'PSPromptMode' -Value $Mode -Scope 'Global'
        $varPSPromptMode = Get-Variable -Name 'PSPromptMode'
        $varPSPromptMode.Description = 'Function Confiuration Variable'
 
        # Limit values to the variable
        $varPSPromptModeAtt = New-Object System.Management.Automation.ValidateSetAttribute('Normal','Cmd', 'Dollar','Pound','Simple','None')
        $varPSPromptMode.Attributes.Add($varPSPromptModeAtt)
 
        # Set the variable to readonly, and all scope
        $varPSPromptMode.Options = 'ReadOnly, AllScope'
 
    }
    # Update configurations
    # To update a read-only variable, you need to add option '-force'
    Set-Variable -Name PSPromptMode -Value $Mode -Force
}
