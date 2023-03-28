Add-Type -AssemblyName PresentationFramework

[xml]$xaml = Get-Content -Path ".\gloslapp.xaml"
$reader = New-Object System.Xml.XmlNodeReader $xaml
$Window = [Windows.Markup.XamlReader]::Load($reader)
#[System.Windows.Markup.ParserContext]::new(), $true)

$comboBox = $Window.FindName("comboBox")

$textBox = $Window.FindName("textBox")

$button1 = $Window.FindName("button1")
$button2 = $Window.FindName("button2")
$button3 = $Window.FindName("button3")


$comboBox.Items.Add("Läxa 1")
$comboBox.Items.Add("Läxa 2")
$comboBox.Items.Add("Läxa 3")
# -->
#$comboBoxOptions = GetAvailableTxtFiles $pathTxtFolder
#foreach ($file in $comboBoxOptions) {
#    $checkedListBox.Items.Add($file.Name)
#}


$Window.ShowDialog() | Out-Null



