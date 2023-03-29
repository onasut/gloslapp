Add-Type -AssemblyName PresentationFramework

# Läser in xaml-koden från en fil
[xml]$xaml = Get-Content -Path "filePicker.xaml"

# Skapar ett fönster från xaml-koden
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Hittar kontrollerna i fönstret
$comboBox = $window.FindName("comboBox")
$okButton = $window.FindName("okButton")

# Skapar en lista av objekt som representerar valen
$choices = Get-ChildItem -Path "C:\github\gloslapp-1\ListorMedOrd" -Filter "*.*" | ForEach-Object {
    New-Object PSObject -Property @{
        Name = $_.Name
        IsSelected = $false
    }
}

# Binder comboBox till listan av val
$comboBox.ItemsSource = $choices

# Skapar en funktion som returnerar de valda filnamnen som en sträng
function GetSelectedFileNames {
    $selectedItems = $choices | Where-Object { $_.IsSelected }
    $fileNames = $selectedItems | Select-Object -ExpandProperty Name
    return ($fileNames -join ", ")
}

# Binder Text-egenskapen till funktionen
$comboBox.SetBinding([System.Windows.Controls.ComboBox]::TextProperty, [System.Windows.Data.Binding]::new("GetSelectedFileNames"))

# Skapar en händelsehanterare för ok-knappen
$okButton.Add_Click({
    # Hämtar de valda filnamnen från comboBox
    $selectedItems = $choices | Where-Object { $_.IsSelected } | ForEach-Object { $_.Name }
    
    # Tilldelar de valda filnamnen till en array $fileNames
    $global:fileNames = @($selectedItems)
    
    # Stänger fönstret
    $window.Close()
})

# Visar fönstret
$window.ShowDialog()