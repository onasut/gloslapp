# Ladda System.Windows.Forms namnrymden
Add-Type -AssemblyName System.Windows.Forms

# Ange sökvägen till mappen och mönstret för filnamnen
$folder = "C:\github\gloslapp-1\ListorMedOrd"
$pattern = "*.txt"

# Hämta alla filer i mappen som matchar mönstret
$files = Get-ChildItem -Path $folder -Filter $pattern

# Skapa ett gui-formulär
$form = New-Object System.Windows.Forms.Form
$form.Text = "Välj filer"
$form.Size = New-Object System.Drawing.Size(400,300)
$form.StartPosition = "CenterScreen"

# Skapa en lista med kryssrutor
$checkedListBox = New-Object System.Windows.Forms.CheckedListBox
$checkedListBox.Location = New-Object System.Drawing.Size(20,20)
$checkedListBox.Size = New-Object System.Drawing.Size(300,200)
$checkedListBox.CheckOnClick = $true

# Lägg till filnamnen som objekt i listan
foreach ($file in $files) {
    $checkedListBox.Items.Add($file.Name)
}

# Skapa en OK-knapp
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Size(150,240)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = "OK"
$okButton.DialogResult = "OK"

# Lägg till listan och knappen till formuläret
$form.Controls.Add($checkedListBox)
$form.Controls.Add($okButton)

# Visa formuläret och få resultatet
$result = $form.ShowDialog()

# Om användaren klickade på OK, visa de valda filnamnen
if ($result -eq "OK") {
    foreach ($item in $checkedListBox.CheckedItems) {
        Write-Host "Du valde: $item"
    }
}