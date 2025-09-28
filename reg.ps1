Add-Type -AssemblyName System.Windows.Forms

# --- Select EXE ---
$FileDialog = New-Object System.Windows.Forms.OpenFileDialog
$FileDialog.Filter = "Executable Files (*.exe)|*.exe"
$FileDialog.Title = "Select an Application"
if ($FileDialog.ShowDialog() -ne "OK") {
    Write-Host "No file selected. Exiting."
    exit
}
$ExePath = $FileDialog.FileName

# --- Prompt for Name ---
$AppName = Read-Host "Enter the name you want to use for this shortcut"

if ([string]::IsNullOrWhiteSpace($AppName)) {
    Write-Host "Name cannot be empty. Exiting."
    exit
}

# --- Ask if user wants to choose an icon ---
$IconDialog = New-Object System.Windows.Forms.OpenFileDialog
$IconDialog.Filter = "Icon Files (*.ico)|*.ico"
$IconDialog.Title = "Select an Icon (Optional)"
$UseIcon = $IconDialog.ShowDialog()
if ($UseIcon -eq "OK") {
    $IconPath = $IconDialog.FileName
} else {
    $IconPath = $ExePath  # fallback to exe's own icon
}

# --- Registry Path for Current User ---
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\$AppName.exe"

# --- Create Registry Key ---
New-Item -Path $RegPath -Force | Out-Null
Set-ItemProperty -Path $RegPath -Name "(Default)" -Value $ExePath
Set-ItemProperty -Path $RegPath -Name "Path" -Value (Split-Path $ExePath)
Set-ItemProperty -Path $RegPath -Name "Icon" -Value $IconPath

# --- Create Start Menu Shortcut ---
$StartMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\$AppName.lnk"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($StartMenuPath)
$Shortcut.TargetPath = $ExePath
$Shortcut.WorkingDirectory = (Split-Path $ExePath)
$Shortcut.IconLocation = $IconPath
$Shortcut.Save()

Write-Host ""
Write-Host "Registry entry created for '$AppName'."
Write-Host "Start Menu shortcut created at:"
Write-Host "$StartMenuPath"
Write-Host ""
Write-Host "You can now launch '$AppName' from Start Menu or Win+R."
