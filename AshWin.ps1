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

$tweaksTab = New-Object System.Windows.Forms.TabPage
$tweaksTab.Text = 'Tweaks'
$tweaksTab.BackColor = $form.BackColor
$tweaksTab.ForeColor = $form.ForeColor

$settingsInfoTab = New-Object System.Windows.Forms.TabPage
$settingsInfoTab.Text = 'Settings and Info'
$settingsInfoTab.BackColor = $form.BackColor
$settingsInfoTab.ForeColor = $form.ForeColor

$tabControl.TabPages.AddRange(@($generalTab, $devTab, $tweaksTab, $settingsInfoTab))

function CreateInstallLocationTextBox {
    $installLocationTextBox = New-Object System.Windows.Forms.TextBox
    $installLocationTextBox.Top = 30
    $installLocationTextBox.Left = 10
    $installLocationTextBox.Width = 560
    $installLocationTextBox.Height = 20
    $installLocationTextBox.Text = "C:\Program Files"
    $installLocationTextBox.ForeColor = [System.Drawing.Color]::Black
    $installLocationTextBox.BackColor = [System.Drawing.Color]::White
    return $installLocationTextBox
}

$generalInstallLocationTextBox = CreateInstallLocationTextBox
$generalTab.Controls.Add($generalInstallLocationTextBox)

$devInstallLocationTextBox = CreateInstallLocationTextBox
$devTab.Controls.Add($devInstallLocationTextBox)

function Install-ChocoPackage {
    param([string]$packageName, [string]$installPath)
    Start-Process -FilePath "powershell.exe" -ArgumentList "choco install $packageName -y --params `"/InstallDir:$installPath`"" -Verb RunAs
}

function Add-AppControl {
    param($tab, $appName, $y, $installLocationTextBox)
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
    $installButton.Left = 520
    $installButton.Width = 60
    $installButton.Height = 20
    $installButton.ForeColor = $form.ForeColor
    $installButton.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
    $installButton.Add_Click({
        Install-ChocoPackage -packageName $checkBox.Text -installPath $installLocationTextBox.Text
    })

    $tab.Controls.Add($checkBox)
    $tab.Controls.Add($installButton)
}

$y = 60
$generalApps = @('GoogleChrome', 'MozillaFirefox', 'Vivaldi', 'NotepadPlusPlus', 'JDownloader', 'WinRAR', 'Discord')
foreach ($app in $generalApps) {
    Add-AppControl -tab $generalTab -appName $app -y $y -installLocationTextBox $generalInstallLocationTextBox
    $y += 30
}

$y = 60
$devApps = @('Git', 'VisualStudioCode', 'Atom', 'SublimeText', 'Postman', 'Docker')
foreach ($app in $devApps) {
    Add-AppControl -tab $devTab -appName $app -y $y -installLocationTextBox $devInstallLocationTextBox
    $y += 30
}

$form.Controls.Add($tabControl)
$form.ShowDialog()
