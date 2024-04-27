# Check and elevate to administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Automatically install Chocolatey
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Automatically installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Ashesh Development Toolkit for Windows'
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$form.ForeColor = [System.Drawing.Color]::WhiteSmoke

$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = 'Fill'
$tabControl.Font = New-Object System.Drawing.Font('Dotum', 10)

$applicationTab = New-Object System.Windows.Forms.TabPage
$applicationTab.Text = 'Applications'
$applicationTab.UseVisualStyleBackColor = $True
$tabControl.TabPages.Add($applicationTab)

# Define applications by category
$appCategories = @{
    'Browsers' = @('firefox', 'googlechrome', 'edge', 'opera gx', 'chromium', 'vivaldi', 'falkon')
    'Communications' = @('discord', 'guilded', 'telegram')
    'File Compression' = @('winrar', '7zip', 'winzip', 'bulk_crap_uninstaller')
    'DevTools' = @('git', 'docker', 'nodejs')
}

# Function to add checkboxes
function Add-AppsToCategory($panel, $apps) {
    $y = 10
    foreach ($app in $apps) {
        $checkBox = New-Object System.Windows.Forms.CheckBox
        $checkBox.Text = $app
        $checkBox.Location = New-Object System.Drawing.Point(10, $y)
        $checkBox.Size = New-Object System.Drawing.Size(200, 24)
        $checkBox.Font = New-Object System.Drawing.Font('Dotum', 8)
        $checkBox.ForeColor = [System.Drawing.Color]::WhiteSmoke
        $panel.Controls.Add($checkBox)
        $y += 30
    }
}

# Add categorized apps to the tab
foreach ($category in $appCategories.Keys) {
    $groupBox = New-Object System.Windows.Forms.GroupBox
    $groupBox.Text = $category
    $groupBox.Font = New-Object System.Drawing.Font('Dotum', 10, [System.Drawing.FontStyle]::Bold)
    $groupBox.ForeColor = [System.Drawing.Color]::Cyan
    $groupBox.Location = New-Object System.Drawing.Point(10, 10)
    $groupBox.Size = New-Object System.Drawing.Size(760, 120)
    $groupBox.Padding = New-Object System.Windows.Forms.Padding(10)
    Add-AppsToCategory -panel $groupBox -apps $appCategories[$category]
    $applicationTab.Controls.Add($groupBox)
}

$form.Controls.Add($tabControl)
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
