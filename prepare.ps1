# Configura queste variabili con le informazioni del tuo repository
$owner = "Sunnyday-Software"
$repo = "web-stack-template"

# URL dell'API di GitHub per ottenere l'ultima release
$apiUrl = "https://api.github.com/repos/$owner/$repo/releases/latest"

# Ottieni l'ultima release
$releaseInfo = Invoke-RestMethod -Uri $apiUrl

# Trova l'asset per Windows
$asset = $releaseInfo.assets | Where-Object { $_.name -like "*windows*" }

if (-not $asset) {
    Write-Host "Nessun asset trovato per Windows."
    exit 1
}

$assetUrl = $asset.browser_download_url
$assetName = "$repo-windows-asset.zip"

Write-Host "Scaricamento dell'asset: $assetUrl"

# Scarica l'asset
Invoke-WebRequest -Uri $assetUrl -OutFile $assetName

# Estrai l'asset nella directory corrente
Expand-Archive -Path $assetName -DestinationPath .

# Rimuovi l'archivio scaricato
Remove-Item $assetName

Write-Host "Download e estrazione completati. Il binario si trova nella directory corrente."
