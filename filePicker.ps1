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
#$comboBox.SetBinding([System.Windows.Controls.ComboBox]::TextProperty, [System.Windows.Data.Binding]::new("GetSelectedFileNames"))
$obj = New-Object PSObject
$obj | Add-Member -MemberType ScriptMethod -Name GetSelectedFileNames -Value {
    $selectedItems = $choices | Where-Object { $_.IsSelected } | ForEach-Object { $_.Name }
    return ($selectedItems -join ", ")
}

$multiBinding = New-Object System.Windows.Data.MultiBinding
$multiBinding.Converter = [System.Windows.Data.MultiBindingConverter] {
    param($values, $targetType, $parameter, $culture)
    $selectedItems = $values[0] | Where-Object { $_.IsSelected } | ForEach-Object { $_.Name }
    return ($selectedItems -join ", ")
}

$checkBoxBinding = New-Object System.Windows.Data.Binding
$checkBoxBinding.Path = "IsSelected"
$checkBoxBinding.Mode = [System.Windows.Data.BindingMode]::OneWay
$multiBinding.Bindings.Add($checkBoxBinding)

$binding = New-Object System.Windows.Data.Binding
$binding.Mode = [System.Windows.Data.BindingMode]::OneWay
$binding.UpdateSourceTrigger = [System.Windows.Data.UpdateSourceTrigger]::PropertyChanged
$binding.Source = $multiBinding

$comboBox.SetBinding([System.Windows.Controls.ComboBox]::TextProperty, $binding)


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