$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
$VerbosePreference = [System.Management.Automation.ActionPreference]::Continue

function Read-UserInput
{
    param (
        [Parameter(Mandatory = $true)]
        [string] $Prompt,

        [Parameter(Mandatory = $false)]
        [string] $DefaultValue
    )

    if ($PSBoundParameters.ContainsKey('DefaultValue')) {
        $value = Read-Host -Prompt ('{0} [{1}]' -f $Prompt, $DefaultValue)
        if ([string]::IsNullOrWhiteSpace($value)) { $DefaultValue } else { $value }
    } else {
        do {
            $value = Read-Host -Prompt ('{0}' -f $Prompt)
        } while ([string]::IsNullOrWhiteSpace($value))
        $value
    }
}

$sshExe = 'C:\Windows\System32\OpenSSH\ssh.exe'
$params = [PSCustomObject] @{
    Destination = $null
    UserName    = 'vmadmin'
    Port        = '22'
    KeyFilePath = 'D:\OneDrive - Microsoft\Keys\azure-vm-general'
}

$params.Destination = Read-UserInput -Prompt 'Destination'
$params.UserName = Read-UserInput -Prompt 'User Name' -DefaultValue $params.UserName
$params.Port = Read-UserInput -Prompt 'Port' -DefaultValue $params.Port
$params.KeyFilePath = Read-UserInput -Prompt 'Auth Key File' -DefaultValue $params.KeyFilePath

$cmdlineParts = @(
    '& ' + '"' + $sshExe + '"',
    '-i', '"' + $params.KeyFilePath + '"',
    '-l', $params.UserName,
    '-p', $params.Port,
    $params.Destination
)
$cmdline = $cmdlineParts -join ' '

Write-Verbose -Message $cmdline
Invoke-Expression -Command $cmdline
