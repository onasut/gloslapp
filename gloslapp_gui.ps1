
# Imports
Add-Type -AssemblyName PresentationFramework
Import-Module .\GlosFunktioner.psm1 # <--

# References
$pathXml = ".\gloslapp.xaml"
$pathTxtFolder = ".\ListorMedOrd"

# Read complete list of files
$global:allTxtFiles = GetAvailableTxtFiles $pathTxtFolder

# Per default, select the last one
$last = $allTxtFiles.Count - 1
$allTxtFiles[$last].IsChecked = $true

# Read words from selected files and pick a random word for starters
$selectedFiles = $allTxtFiles | Where-Object { $_.IsChecked }
$global:Words = ReadWordsFromTxtFiles($pathTxtFolder, $selectedFiles)
$global:currentIndex = GetRandomNumber $Words.Count

# Loading gui
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
[xml]$xaml = Get-Content -Path $pathXml
$reader = New-Object System.Xml.XmlNodeReader $xaml
$Window = [Windows.Markup.XamlReader]::Load($reader)

#==============
# Bindings
#==============

# Dropdown menu to select which textfiles to use
$checkListOptions = $allTxtFiles
$CheckListBox = $Window.FindName("CheckListBox")
$CheckListBox.ItemsSource = $checkListOptions

# Glosa
$Glosa = $Window.FindName("textBlockGlosa")
$Glosa.Text = $words[$currentIndex]

# Knapp för Föregående
$buttonPrev = $Window.FindName("buttonPrev")
$buttonPrev.Add_Click({
    $currentIndex = DecreaseIndex $currentIndex $Words.Count
    $global:currentIndex = $currentIndex
    $Glosa.Text = $words[$currentIndex]
})

# Knapp för Slumpvis
$buttonRand = $Window.FindName("buttonRand")
$buttonRand.Add_Click({ 
    $WordCount = $global:Words.Count
    $global:currentIndex = GetRandomNumber $WordCount
    $currentIndex = $global:currentIndex
    $Glosa.Text = $words[$currentIndex]
    # write-host "count: $wordcount index: $currentIndex"
})

# Knapp för Nästa
$buttonNext = $Window.FindName("buttonNext")
$buttonNext.Add_Click({ 
    $currentIndex = IncreaseIndex $currentIndex $Words.Count
    $global:currentIndex = $currentIndex
    $Glosa.Text = $words[$currentIndex]
})


#$words
$Window.ShowDialog() | Out-Null



