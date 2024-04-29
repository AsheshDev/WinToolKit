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

function CreateTabPage($text) {
    $page = New-Object System.Windows.Forms.TabPage
    $page.Text = $text
    $page.BackColor = $form.BackColor
    $page.ForeColor = $form.ForeColor
    $page.AutoScroll = $True
    return $page
}

$generalTab = CreateTabPage 'General Applications'
$devTab = CreateTabPage 'Dev Applications'
$tweaksTab = CreateTabPage 'Tweaks'
$settingsInfoTab = CreateTabPage 'Settings and Info'

$tabControl.TabPages.AddRange(@($generalTab, $devTab, $tweaksTab, $settingsInfoTab))

function CreateInstallLocationTextBox {
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Top = 30
    $textBox.Left = 10
    $textBox.Width = 560
    $textBox.Height = 20
    $textBox.Text = "C:\Program Files"
    $textBox.ForeColor = [System.Drawing.Color]::Black
    $textBox.BackColor = [System.Drawing.Color]::White
    return $textBox
}

$generalInstallLocationTextBox = CreateInstallLocationTextBox
$generalTab.Controls.Add($generalInstallLocationTextBox)

$devInstallLocationTextBox = CreateInstallLocationTextBox
$devTab.Controls.Add($devInstallLocationTextBox)

function Install-ChocoPackage {
    param([string]$packageName, [string]$installPath)
    try {
        $arguments = "choco install $packageName -y --params `"/InstallDir:$installPath`""
        Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -Verb RunAs -NoNewWindow
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to install $packageName`nError: $($_.Exception.Message)", "Installation Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
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

function PopulateTabWithApps($tab, $apps, $installLocationTextBox) {
    $y = 60
    foreach ($app in $apps) {
        Add-AppControl -tab $tab -appName $app -y $y -installLocationTextBox $installLocationTextBox
        $y += 30
    }
}

PopulateTabWithApps $generalTab @('GoogleChrome', 'MozillaFirefox', 'Vivaldi', 'NotepadPlusPlus', 'JDownloader', 'WinRAR', 'Discord') $generalInstallLocationTextBox
PopulateTabWithApps $devTab @('Git', 'VisualStudioCode', 'Atom', 'SublimeText', 'Postman', 'Docker') $devInstallLocationTextBox

$form.Controls.Add($tabControl)
$form.ShowDialog()
