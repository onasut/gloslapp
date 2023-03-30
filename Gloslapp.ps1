
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
$global:currentIndex = GetRandomIndex $Words.Count

# Loading xaml gui
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
[xml]$xaml = Get-Content -Path $pathXml
$reader = New-Object System.Xml.XmlNodeReader $xaml
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Populate menu to select which textfiles to use 
$CheckListBox = $Window.FindName("CheckListBox")
$CheckListBox.ItemsSource = $allTxtFiles

# Expander to make the menu drop down 
$Expander = $Window.FindName("Expander")
#$Expander.Header= "Välj läxor" # <-- issue. encoding problem when setting it from here. reverting to settings header in xaml for now. investigate.
$Expander.Add_Collapsed({
    $selectedFiles = $allTxtFiles | Where-Object { $_.IsChecked }
    $global:Words = ReadWordsFromTxtFiles($pathTxtFolder, $selectedFiles)
    $global:currentIndex = GetRandomIndex $Words.Count
    $Glosa.Text = $words[$currentIndex]
})

# Text - Glosa
$Glosa = $Window.FindName("textBlockGlosa")
$Glosa.Text = $words[$currentIndex]

# Button - Previous
$buttonPrev = $Window.FindName("buttonPrev")
$buttonPrev.Add_Click({
    $currentIndex = DecreaseIndex $currentIndex $Words.Count
    $global:currentIndex = $currentIndex
    $Glosa.Text = $words[$currentIndex]
})

# Button - Random
$buttonRand = $Window.FindName("buttonRand")
$buttonRand.Add_Click({ 
    $WordCount = $Words.Count
    $currentIndex = GetRandomIndex $WordCount
    $global:currentIndex = $currentIndex
    $Glosa.Text = $words[$currentIndex]
    # write-host "count: $wordcount index: $currentIndex"
})

# Button - Next
$buttonNext = $Window.FindName("buttonNext")
$buttonNext.Add_Click({ 
    $currentIndex = IncreaseIndex $currentIndex $Words.Count
    $global:currentIndex = $currentIndex
    $Glosa.Text = $words[$currentIndex]
})


#$words
$Window.ShowDialog() | Out-Null



