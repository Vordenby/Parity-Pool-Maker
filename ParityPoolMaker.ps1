#Admin Autostart
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    $args = @(
        '-NoProfile'
        '-ExecutionPolicy', 'Bypass'
        '-File', "`"$PSCommandPath`""
    )
    Start-Process -FilePath "powershell.exe" -Verb RunAs -ArgumentList $args
    exit
}

#Trying find poolable disks

$poolable = Get-PhysicalDisk | Where-Object { $_.CanPool -eq $true }

if ($poolable.Count -lt 3) {
    Write-Host "Needed more than 2 poolable disks for pool creation (Parity pool creation)" -ForegroundColor Red
    Write-Host "Needed to be checked CannotPoolReason if disks are not supported" -ForegroundColor Yellow
    return
}

#GUI choosing disks for pool
$selected = $poolable | Out-GridView -Title "Disks for new Parity Pool (Ctrl/Shift for multiple choosing)" -PassThru

if (-not $selected -or $selected.Count -lt 3) {
    Write-Host "Needed more than 2 disks..." -ForegroundColor Red
    return
}

$physicalDisks = @($selected)

$PoolName = Read-Host "Write name of the pool (standart: PoolParity)"
if ([string]::IsNullOrWhiteSpace($PoolName)) { $PoolName = "PoolParity" }

$vdName = Read-Host "Write name of the vd (standart: ParityDisk)"
if ([string]::IsNullOrWhiteSpace($vdName)) { $vdName = "ParityDisk" }

#Pool creation
$subsystem = (Get-StorageSubSystem | Select-Object -First 1).FriendlyName

New-StoragePool `
    -FriendlyName $PoolName `
    -StorageSubsystemFriendlyName $subsystem `
    -PhysicalDisks $physicalDisks | Out-Null

Write-Host "The pool '$PoolName' has been created" -ForegroundColor Green

$createParity = Read-Host "Create a volume with parity? Will be used all available size in the pool. (Y/N)"

if ($createParity -notmatch '^(Y|y)$') {
    Write-Host "Volume creation has been skipped." -ForegroundColor Yellow
    return
}

Start-Sleep -Seconds 3

#Creating a new volume with parity
New-VirtualDisk `
    -StoragePoolFriendlyName $PoolName `
    -FriendlyName $vdName `
    -ResiliencySettingName Parity `
    -UseMaximumSize | Out-Null

#Initialization&partition&format
Get-VirtualDisk -FriendlyName $vdName |
    Get-Disk |
    Initialize-Disk -PassThru |
    New-Partition -AssignDriveLetter -UseMaximumSize |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel $vdName

Write-Host "All is set and donw!" -ForegroundColor Green