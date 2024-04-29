Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Ashesh Development Toolkit for Windows'
$form.Size = New-Object System.Drawing.Size(600, 700)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(13, 17, 23)
$form.ForeColor = [System.Drawing.Color]::FromArgb(255, 235, 59)

$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = 'Fill'
$tabControl.BackColor = $form.BackColor
$tabControl.ForeColor = $form.ForeColor

$generalTab = New-Object System.Windows.Forms.TabPage
$generalTab.Text = 'General Applications'
$generalTab.BackColor = $form.BackColor
$generalTab.ForeColor = $form.ForeColor
$generalTab.AutoScroll = $True

$devTab = New-Object System.Windows.Forms.TabPage
$devTab.Text = 'Dev Applications'
$devTab.BackColor = $form.BackColor
$devTab.ForeColor = $form.ForeColor
$devTab.AutoScroll = $True

$settingsInfoTab = New-Object System.Windows.Forms.TabPage
$settingsInfoTab.Text = 'Settings and Info'
$settingsInfoTab.BackColor = $form.BackColor
$settingsInfoTab.ForeColor = $form.ForeColor

$tabControl.TabPages.AddRange(@($generalTab, $devTab, $settingsInfoTab))

function Install-ChocoPackage {
    param([string]$packageName, [string]$installPath)
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = "powershell.exe"
    $processInfo.RedirectStandardError = $true
    $processInfo.RedirectStandardOutput = $true
    $processInfo.UseShellExecute = $false
    $processInfo.Arguments = "choco install $packageName -y --params=`"'/InstallDir:$installPath'`""
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo
    $process.Start() | Out-Null
    $process.WaitForExit()
    $output = $process.StandardOutput.ReadToEnd()
    $error = $process.StandardError.ReadToEnd()
    if ($process.ExitCode -ne 0) {
        [System.Windows.Forms.MessageBox]::Show("Error: $error")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Installed: $output")
    }
}

function Add-AppControl {
    param($tab, $appName, $y)
    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Text = $appName
    $checkBox.Top = $y
    $checkBox.Left = 10
    $checkBox.AutoSize = $True
    $checkBox.ForeColor = $form.ForeColor
    $checkBox.BackColor = $tab.BackColor

    $installButton = New-Object System.Windows.Forms.Button
    $installButton.Text = "Install"
    $installButton.Top = $y
    $installButton.Left = 250
    $installButton.Width = 100
    $installButton.Height = 20
    $installButton.Add_Click({
        Install-ChocoPackage -packageName $checkBox.Text -installPath "C:\Program Files"
    })

    $tab.Controls.Add($checkBox)
    $tab.Controls.Add($installButton)
}

$y = 40
$generalApps = @("notepadplusplus", "googlechrome", "firefox")
foreach ($app in $generalApps) {
    Add-AppControl -tab $generalTab -appName $app -y $y
    $y += 30
}

$y = 40
$devApps = @("git", "vscode", "docker")
foreach ($app in $devApps) {
    Add-AppControl -tab $devTab -appName $app -y $y
    $y += 30
}

$form.Controls.Add($tabControl)
$form.ShowDialog()
