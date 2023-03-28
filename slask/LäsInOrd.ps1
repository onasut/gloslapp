# Skapa en tom array
$ord = @()
$fileContent = @()

# Loopa igenom alla filer med ord
Get-ChildItem Get-ChildItem -Path .\ListorMedOrd -File *.txt | ForEach-Object {

  # Lägg till innehållet i varje fil till arrayen med -Raw parameter
  # Detta läser hela filen som en enda sträng
  $fileContent += Get-Content -Raw $_.FullName -Encoding UTF8

}

# Ta bort radbrytningar från varje element i arrayen och ersätt dem med mellanslag
$fileContent = $fileContent -replace '\r|\n', ''

# Dela upp varje element i arrayen med mellanslag och skapa en ny array
$ord = $fileContent -split ' '

# Antal ord?
$ord.Count