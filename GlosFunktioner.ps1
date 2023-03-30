

function GetAvailableTxtFiles ($Path) {
<#
.SYNOPSIS
    This function creates an object for handling txt-files. The object can be bound to a menu.

.DESCRIPTION
    The property Name correspons to filename.
    The property IsChecked determines if the file is selected or not.

.PARAMETER Path
    Specifies the path where the .txt-files are located.

.EXAMPLE
    PS C:\> GetAvailableTxtFiles -Path '.\ListsOfThings'
#>
    $menuItems = Get-ChildItem -Path $Path -Filter "*.txt" | ForEach-Object {
        New-Object PSObject -Property @{
            Name = $_.Name
            IsChecked = $false
        }
    }
    return $menuItems
}


function ReadWordsFromTxtFiles ($SelectedFiles) {
    # Not suited for reuse. Name of subfolder hard coded.

    $words = @()
    $fileContents = @()
    # Read file content
    foreach ($file in $SelectedFiles.Name) {
        $fileContents += Get-Content -Raw -Path ".\ListorMedOrd\$file" -Encoding UTF8
    }

    # Ta bort radbrytningarna och överflödiga mellanslag
    $fileContents = $fileContents -replace '\s+', ' '
    $fileContents = $fileContents -replace '\s+', ' '

    # Dela upp varje element i arrayen med split på mellanslag
    $words = $fileContents -split ' '

    return $words
}


function GetRandomIndex ($arrayLength) {
<#
.SYNOPSIS
    This function returns a random index within the given range.

.DESCRIPTION
    The script randomizes an integer between 0 and the length of the array.

.PARAMETER arrayLength
    Specifies the index range - the count of items in the array.

.EXAMPLE
    PS C:\> $currentIndex = GetRandomIndex -arrayLength $myArray.Count
#>
    $randomIndex = Get-Random -Min 0 -Max $arrayLength
    return $randomIndex
}

function RandomWord {
    $WordCount = $Words.Count
    $currentIndex = GetRandomIndex $WordCount
    $global:currentIndex = $currentIndex
    $Glosa.Text = $words[$currentIndex]
}


function IncreaseIndex($currentIndex,$arrayLength) {
<#
.SYNOPSIS
    This function increases a circular index by 1 and returns the new index.

.DESCRIPTION
    The script handles out of index range by using modulo.

.PARAMETER currentIndex
    Specifies the starting position to increase from.

.EXAMPLE
    PS C:\> $currentIndex = IncreaseIndex $currentIndex $myArray.Count
#>
    return ($currentIndex + 1 - $arrayLength) % $arrayLength
}

function NextWord {
    $currentIndex = IncreaseIndex $currentIndex $Words.Count
    $global:currentIndex = $currentIndex
    $Glosa.Text = $words[$currentIndex]
}


function DecreaseIndex($currentIndex,$arrayLength) {
<#
.SYNOPSIS
    This function decreases a circular index by 1 and returns the new index.

.DESCRIPTION
    The script handles out of index range by using modulo.

.PARAMETER currentIndex
    Specifies the starting position to decrease from.

.EXAMPLE
    PS C:\> $currentIndex = DecreaseIndex $currentIndex $myArray.Count
#>
    return ($currentIndex - 1 + $arrayLength) % $arrayLength
}

function PreviousWord {
    $currentIndex = DecreaseIndex $currentIndex $Words.Count
    $global:currentIndex = $currentIndex
    $Glosa.Text = $words[$currentIndex]
}



#########################
# Unused functions

function SetLastTxtFileSelected ($choices) {
    $last = $choices.Count - 1
    $choices[$last].IsChecked = $true
return $choices
}


function GetSelectedFiles ($choices) {
$selectedItems = $choices | Where-Object { $_.IsChecked }
return $selectedItems
}

function GetRandomWord ($words) {
    $randomWord= Get-Random -InputObject $words
    return $randomWord
}



# Tests

#$pathTxtFolder = ".\ListorMedOrd"
#$allTxtFiles = GetAvailableTxtFiles $pathTxtFolder
#$allTxtFiles = SetLastTxtFileSelected($allTxtFiles)
#$allTxtFiles

#$availableTxtFiles[2].IsChecked = $true
#$availableTxtFiles[3].IsChecked = $true
#$selectedFiles = GetSelectedFiles $allTxtFiles
#$selectedFiles

#$Words = ReadWordsFromTxtFiles($pathTxtFolder, $selectedFiles)
#Words

#[int]$WordCount = $Words.Count
#write-host "hittade $NumberOfWords ord i filerna"

#[int]$currentIndex = GetRandomNumber $Words.Count
#[string]$currentWord = $words[$currentIndex]
#write-host "$currentIndex : $currentWord"

#$words[$currentIndex]
#$currentIndex = DecreaseIndex $currentIndex $WordCount
#$words[$currentIndex]


