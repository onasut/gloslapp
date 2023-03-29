
# Imports
Add-Type -AssemblyName PresentationFramework
Import-Module .\GlosFunktioner.psm1 # <--

# References
$pathXml = ".\gloslapp.xaml"
$pathTxtFolder = ".\ListorMedOrd"

# Read list of files for dropdown
$allTxtFiles = GetAvailableTxtFiles $pathTxtFolder

# Default, select the last one
$last = $allTxtFiles.Count - 1
$allTxtFiles[$last].IsChecked = $true

# Read words from selected files and pick a random word for starters
$selectedFiles = $allTxtFiles | Where-Object { $_.IsChecked }
$Words = ReadWordsFromTxtFiles($pathTxtFolder, $selectedFiles)
$currentIndex = GetRandomNumber $Words.Count

# Loading gui
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
[xml]$xaml = Get-Content -Path $pathXml
$reader = New-Object System.Xml.XmlNodeReader $xaml
$Window = [Windows.Markup.XamlReader]::Load($reader)

#==============
# Bindings
#==============

# Dropdown menu to select which textfiles to use
$CheckListBox = $Window.FindName("CheckListBox")
$checkListOptions = $allTxtFiles
#ForEach ($option in $checkListOptions) {
#    $CheckListBox.Items.Add($option.Name)
#}
$CheckListBox.ItemsSource = $checkListOptions

# Glosa
$Glosa = $Window.FindName("textBlockGlosa")
$Glosa.Text = $words[$currentIndex]

# Knapp för Föregående
$buttonPrev = $Window.FindName("buttonPrev")
$buttonPrev.Add_Click({ 
    write-host "prev"
    $currentIndex = DecreaseIndex $currentIndex $Words.Count
    $Glosa.Text = $words[$currentIndex]
})

# Knapp för Slumpvis
$buttonRand = $Window.FindName("buttonRand")
$buttonRand.Add_Click({ 
    write-host "rand"
    $currentIndex = GetRandomNumber $WordCount
    $Glosa.Text = $words[$currentIndex]
})

# Knapp för Nästa
$buttonNext = $Window.FindName("buttonNext")
$buttonNext.Add_Click({ 
    write-host "next"
    $currentIndex = IncreaseIndex $currentIndex $Words.Count
    $Glosa.Text = $words[$currentIndex]
})



$Window.ShowDialog() | Out-Null



