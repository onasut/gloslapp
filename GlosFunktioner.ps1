

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
        $last = $choices.Count - 1
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


function IncreaseIndex($currentIndex,$arrayLength) {
    return ($currentIndex + 1 - $arrayLength) % $arrayLength
}

function DecreaseIndex($currentIndex,$arrayLength) {
    return ($currentIndex - 1 + $arrayLength) % $arrayLength
}






# Tests
$pathTxtFolder = ".\ListorMedOrd"
$allTxtFiles = GetAvailableTxtFiles $pathTxtFolder
$allTxtFiles = SetLastTxtFileSelected($allTxtFiles)
#$allTxtFiles

#$availableTxtFiles[0].IsSelected = $true
#$availableTxtFiles[1].IsSelected = $true
$availableTxtFiles[2].IsSelected = $true
$availableTxtFiles[3].IsSelected = $true
#$availableTxtFiles[4].IsSelected = $true
$selectedFiles = GetSelectedFiles $allTxtFiles
#$selectedFiles

$Words = ReadWordsFromTxtFiles($pathTxtFolder, $selectedFiles)
#Words

$WordCount = $Words.Count
#write-host "hittade $NumberOfWords ord i filerna"

[int]$currentIndex = GetRandomNumber $Words.Count
[string]$currentWord = $words[$currentIndex]
#write-host "$currentIndex : $currentWord"

#$words[$currentIndex]
#$currentIndex = DecreaseIndex $currentIndex $WordCount
#$words[$currentIndex]


