# Register my public key (~/.ssh/id_ed25519.pub) to a remote server's authorized_keys
# so that ssh to that server no longer asks for a password. (Windows PowerShell version)
# It asks the remote password ONCE (this time), and never again afterwards.
# usage (with port option)    : powershell -File register_my_public_key_to_remote_opt1_user_at_opt2_address_with_opt3_port.ps1 kevin 192.168.2.50 1122
# usage (without port option) : powershell -File register_my_public_key_to_remote_opt1_user_at_opt2_address_with_opt3_port.ps1 kevin 192.168.2.240
param(
    [Parameter(Mandatory=$true)][string]$IdRemote,    # opt1 : remote user
    [Parameter(Mandatory=$true)][string]$IpRemote,    # opt2 : remote address
    [int]$PortRemote                                  # opt3 : remote port (optional, default 22)
)
$PubKeyPath = "$env:USERPROFILE\.ssh\id_ed25519.pub"
if (-not (Test-Path $PubKeyPath)) {
    Write-Host "public key not found: $PubKeyPath  (make one with: ssh-keygen -t ed25519)"
    exit 1
}
$PubKey = Get-Content $PubKeyPath
$RemoteCmd = "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
if ($PortRemote) {
    $PubKey | ssh "$IdRemote@$IpRemote" -p $PortRemote $RemoteCmd
} else {
    $PubKey | ssh "$IdRemote@$IpRemote" $RemoteCmd
}
