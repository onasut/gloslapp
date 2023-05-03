
# Imports
Add-Type -AssemblyName PresentationFramework
Set-Location $PSScriptRoot
Import-Module .\GlosFunktioner.psd1

# References
$pathXml = ".\gloslapp.xaml"
$pathTxtFolder = ".\ListorMedOrd"

# Read complete list of files
$global:allTxtFiles = GetAvailableTxtFiles $pathTxtFolder

# Per default, select the last one
$last = $allTxtFiles.Count - 1
$allTxtFiles[$last].IsChecked = $true

# Read words from selected files
$selectedFiles = $allTxtFiles | Where-Object { $_.IsChecked }
$global:words = ReadWordsFromTxtFiles($pathTxtFolder, $selectedFiles)

# Pick a word for starters
$global:currentIndex = $Words[0]
RandomWord

# Create a counter to track practice
$global:seenWords = 0

# Loading xaml gui
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
[xml]$xaml = Get-Content -Path $pathXml
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Populate menu to select which textfiles to use 
$checkListBox = $window.FindName("CheckListBox")
$checkListBox.ItemsSource = $allTxtFiles

# Expander to make the menu drop down 
$expander = $window.FindName("Expander")
#$Expander.Header= "Välj läxor" # <-- issue. encoding problem when setting it from here. reverting to settings header in xaml for now. investigate.
$expander.Add_Collapsed({
    $selectedFiles = $allTxtFiles | Where-Object { $_.IsChecked }
    $global:words = ReadWordsFromTxtFiles($pathTxtFolder, $selectedFiles)
    RandomWord
})

# Text - Glosa
$glosa = $window.FindName("textBlockGlosa")
$glosa.Text = $words[$currentIndex]

# Button - Previous
$buttonPrev = $Window.FindName("buttonPrev")
$buttonPrev.Add_Click({
    PreviousWord
})

# Button - Random
$buttonRand = $Window.FindName("buttonRand")
$buttonRand.Add_Click({ 
    RandomWord
})

# Button - Next
$buttonNext = $Window.FindName("buttonNext")
$buttonNext.Add_Click({ 
    NextWord
})

# Keyboard bindings
$window.Add_KeyDown({
    switch ($_.Key) {
        "Up"    { RandomWord }
        "Down"  { RandomWord }
        "Space" { RandomWord }
        "Left"  { PreviousWord }
        "Right" { NextWord }
    }
})

$window.Add_Closing({
    $seenWords | Out-File -FilePath .\seenWords.txt -Append
    Write-Host "Ord som visats: $seenWords"
})

#$words
$window.ShowDialog() | Out-Null



