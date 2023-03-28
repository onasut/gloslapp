

function GetAvailableTxtFiles ($folder) {
    $choices = Get-ChildItem -Path $folder -Filter "*.txt" | ForEach-Object {
        New-Object PSObject -Property @{
            Name = $_.Name
            IsSelected = $false
        }
    }
    return $choices
}


function SetLastTxtFileSelected ($choices) {
        $last = $choices.Count
        $choices[$last].IsSelected = $true
    return $choices
}


function GetSelectedFiles ($choices) {
    $selectedItems = $choices | Where-Object { $_.IsSelected }
    return $selectedItems
}


function ReadWordsFromTxtFiles ($selectedFiles) {
    $words = @()
    $fileContents = @()
    # Read file content
    foreach ($file in $selectedFiles.Name) {
        $fileContents += Get-Content -Raw -Path ".\ListorMedOrd\$file" -Encoding UTF8
    }

    # Ta bort radbrytningarna
    #$fileContents = $fileContents -replace '\r|\n', ''
    $fileContents = $fileContents -replace '\s+', ' '

    # Dela upp varje element i arrayen med split på mellanslag
    $words = $fileContents -split ' '
    return $words
}


function GetRandomWord ($words) {
    $randomWord= Get-Random -InputObject $words
    return $randomWord
}

function GetRandomNumber ($wordCount) {
    $randomNumber = Get-Random -Min 0 -Max $wordCount
    return $randomNumber
}

function GetPreviousNumber ($current, $total) {
    $previous = $current - 1
    if ($previous -eq 0) { $previous = $total }
    return $previous
}



# Tests
$pathTxtFolder = ".\ListorMedOrd"
$availableTxtFiles = GetAvailableTxtFiles $pathTxtFolder
#$availableTxtFiles

$availableTxtFiles[0].IsSelected = $true
$availableTxtFiles[1].IsSelected = $true
$availableTxtFiles[2].IsSelected = $true
$availableTxtFiles[3].IsSelected = $true
$availableTxtFiles[4].IsSelected = $true
$selectedFiles = GetSelectedFiles $availableTxtFiles
#$selectedFiles

$Words = ReadWordsFromTxtFiles($pathTxtFolder, $selectedFiles)
#Words

$NumberOfWords = $Words.Count
write-host "hittade $NumberOfWords ord i filerna"

write-host "ett smakprov"
$currentNumber = GetRandomNumber ($Words.Count)
$currentWord = $words[$currentNumber]
write-host "$currentNumber : $currentWord"

$currentNumber = GetRandomNumber ($Words.Count)
$currentWord = $words[$currentNumber]
write-host "$currentNumber : $currentWord"

$currentNumber = GetRandomNumber ($Words.Count)
$currentWord = $words[$currentNumber]
write-host "$currentNumber : $currentWord"





#function GetSelectedFileNames ($choices) {
#    $selectedItems = $choices | Where-Object { $_.IsSelected }
#    $fileNames = $selectedItems | Select-Object -ExpandProperty Name
#    return ($fileNames -join ", ")
#}