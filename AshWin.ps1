# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting the script with Administrator rights..."
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Check and install Chocolatey if it's not installed
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Ashesh Development Toolkit for Windows'
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$form.ForeColor = [System.Drawing.Color]::WhiteSmoke

$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = 'Fill'
$tabControl.Font = New-Object System.Drawing.Font('Dotum', 10)

$generalTab = New-Object System.Windows.Forms.TabPage
$generalTab.Text = 'General Applications'
$generalTab.UseVisualStyleBackColor = $True

$devTab = New-Object System.Windows.Forms.TabPage
$devTab.Text = 'Dev Applications'
$devTab.UseVisualStyleBackColor = $True

$gameTab = New-Object System.Windows.Forms.TabPage
$gameTab.Text = 'Gaming'
$gameTab.UseVisualStyleBackColor = $True

$tabControl.TabPages.AddRange(@($generalTab, $devTab, $gameTab))

# Define applications for each category
$generalApps = 'googlechrome', 'firefox', 'vlc', '7zip', 'spotify'
$devApps = 'vscode', 'git', 'docker', 'nodejs', 'python', 'postgresql'
$gameApps = 'steam', 'epicgameslauncher', 'origin', 'gog', 'battle.net'

# Helper function to add apps to tabs
function Add-AppsToTab($tab, $apps) {
    $y = 20
    foreach ($app in $apps) {
        $appButton = New-Object System.Windows.Forms.Button
        $appButton.Text = "Install $app"
        $appButton.Location = New-Object System.Drawing.Point(10, $y)
        $appButton.Size = New-Object System.Drawing.Size(200, 30)
        $appButton.Font = New-Object System.Drawing.Font('Dotum', 8)
        $appButton.BackColor = [System.Drawing.Color]::FromArgb(28, 151, 234)
        $appButton.ForeColor = [System.Drawing.Color]::WhiteSmoke
        $appButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $appButton.Add_Click({
            Start-Process "powershell.exe" -ArgumentList "choco install $app -y" -Verb RunAs
        })
        $tab.Controls.Add($appButton)
        $y += 40
    }
}

# Add applications to tabs
Add-AppsToTab -tab $generalTab -apps $generalApps
Add-AppsToTab -tab $devTab -apps $devApps
Add-AppsToTab -tab $gameTab -apps $gameApps

$form.Controls.Add($tabControl)
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
