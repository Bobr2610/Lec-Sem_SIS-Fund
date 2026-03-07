Write-Host "Building PDF..." -ForegroundColor Cyan

$semFiles = Get-ChildItem -Path "Seminars" -Filter "*.md" | Sort-Object { [int]($_.BaseName -replace '\D+', '') }

$files = @()
$files += $semFiles | ForEach-Object { "Seminars/$($_.Name)" }

if ($files.Count -eq 0) {
    Write-Host "No markdown files found in Seminars/" -ForegroundColor Red
    exit 1
}

Write-Host "Found $($files.Count) files to process" -ForegroundColor Gray

Write-Host "Creating Seminars.pdf..." -ForegroundColor Cyan
pandoc $files `
    -o Seminars.pdf `
    --pdf-engine=xelatex `
    -V geometry:margin=0.5cm `
    -V mainfont="Cambria" `
    -V mathfont="Cambria Math" `
    -V monofont="Consolas" `
    -V pagestyle=empty `
    --from markdown+tex_math_single_backslash+tex_math_dollars-yaml_metadata_block

if ($LASTEXITCODE -eq 0) {
    Write-Host "PDF created successfully: Seminars.pdf" -ForegroundColor Green
    $file = Get-Item Seminars.pdf
    Write-Host "Size: $([math]::Round($file.Length / 1KB, 1)) KB" -ForegroundColor Gray
} else {
    Write-Host "Error creating Seminars.pdf" -ForegroundColor Red
}
