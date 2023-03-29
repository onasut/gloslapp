# Ange filnamn
$file = Get-ChildItem -Path .\ListorMedOrd | Select-Object -Last 1
$filePath = '.\ListorMedOrd\' + $($file.Name)

# Hämta innehållet i filen
$content = Get-Content -Path $filePath -Raw -Encoding UTF8

# Ta bort dubbla mellanslag och nya rader
$content = $content -replace '\s+', ' '

# Ta bort alla radbrytningar från innehållet
$content = $content -replace '\r|\n', ''

# Dela upp innehållet i ord
$words = $content.Split(" ")

# Definiera en funktion för att skapa ett slumpmässigt ord
Function Create-RandomWord {
    # Välj ett slumpmässigt ord från ordlistan
    $randomWord = Get-Random -InputObject $words

    # Returnera det slumpmässiga ordet
    return $randomWord
}





# Skapa ett nytt formulär med en knapp och en etikett
$form = New-Object System.Windows.Forms.Form
$form.Text = "Öva på ord"
$form.Size = New-Object System.Drawing.Size(300,300)

$button = New-Object System.Windows.Forms.Button
$button.Text = "Nästa"
$button.Location = New-Object System.Drawing.Point(100,200)
$button.Size = New-Object System.Drawing.Size(100,30)

$label = New-Object System.Windows.Forms.Label
$label.Text = Create-RandomWord # Visa ett slumpmässigt ord när formuläret öppnas
$label.Location = New-Object System.Drawing.Point(100,50)
$label.Size = New-Object System.Drawing.Size(100,130)
# Centrera etiketten i formuläret
$label.TextAlign = "MiddleCenter"
# Öka textstorleken till 20 punkter
$label.Font = New-Object System.Drawing.Font ("Microsoft Sans Serif", 40)

# Lägg till en händelsehanterare för knappen som anropar funktionen Create-RandomWord och uppdaterar etiketten med det nya ordet
$button.Add_Click({
    $label.Text = Create-RandomWord
})

# Lägg till knappen och etiketten till formuläret
$form.Controls.Add($button)
$form.Controls.Add($label)

# Visa formuläret
$form.ShowDialog()