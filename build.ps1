# Get the current directory
$currentDir = Get-Location

# Check if manifest.json exists
$manifestPath = Join-Path $currentDir "manifest.json"
if (-not (Test-Path $manifestPath)) {
    Write-Error "manifest.json not found in current directory"
    exit 1
}

try {
    $manifestContent = Get-Content $manifestPath -Raw | ConvertFrom-Json
    $version = $manifestContent.version
    Write-Host "Found version: $version" -ForegroundColor Green
} catch {
    Write-Error "Failed to parse manifest.json or extract version"
    exit 1
}

# Create output filename
$outputFileName = "Steamgifts_Companion_v$version.zip"
$outputPath = Join-Path $currentDir $outputFileName

# Remove existing zip file if it exists
if (Test-Path $outputPath) {
    Remove-Item $outputPath -Force
    Write-Host "Removed existing $outputFileName" -ForegroundColor Yellow
}

# Get all files and folders in current directory except the output zip file and this script
$itemsToCompress = Get-ChildItem -Path $currentDir | Where-Object { 
    $_.Name -ne $outputFileName -and 
    $_.Name -ne $MyInvocation.MyCommand.Name -and
    $_.Name -notlike "*.ps1" -and
    $_.Name -notlike ".gitignore" -and
    $_.Name -notlike ".git" -and
    $_.Name -ne "compress.ps1"
}

if ($itemsToCompress.Count -eq 0) {
    Write-Warning "No files found to compress"
    exit 1
}

# Display files to be compressed
Write-Host "Files to compress:" -ForegroundColor Cyan
$itemsToCompress | ForEach-Object { Write-Host "  - $($_.Name)" }

# Create the zip file
try {
    Compress-Archive -Path $itemsToCompress.FullName -DestinationPath $outputPath -CompressionLevel Optimal
    Write-Host "`nSuccessfully created: $outputFileName" -ForegroundColor Green
    
    # Display file size
    $zipSize = (Get-Item $outputPath).Length
    $zipSizeKB = [math]::Round($zipSize / 1KB, 2)
    Write-Host "File size: $zipSizeKB KB" -ForegroundColor Green
    
} catch {
    Write-Error "Failed to create zip file: $_"
    exit 1
}