Write-Host "Building PDFs for all categories..." -ForegroundColor Cyan

# Define categories and filters
$categories = @(
    @{ Name = "SIS_Lectures"; Path = "Lectures"; Filter = "SIS*.md"; Output = "SIS_Lectures.pdf" },
    @{ Name = "FUN_Lectures"; Path = "Lectures"; Filter = "Fun*.md"; Output = "FUN_Lectures.pdf" },
    @{ Name = "SIS_Seminars"; Path = "Seminars"; Filter = "SIS*.md"; Output = "SIS_Seminars.pdf" },
    @{ Name = "FUN_Seminars"; Path = "Seminars"; Filter = "Fun*.md"; Output = "FUN_Seminars.pdf" }
)

foreach ($category in $categories) {
    Write-Host "Processing category: $($category.Name)" -ForegroundColor Cyan

    $files = Get-ChildItem -Path $category.Path -Filter $category.Filter | Sort-Object { [int]($_.BaseName -replace '\D+', '') } | ForEach-Object { $_.FullName }

    if ($files.Count -eq 0) {
        Write-Host "No markdown files found for $($category.Name)" -ForegroundColor Red
        continue
    }

    Write-Host "Found $($files.Count) files to process for $($category.Name)" -ForegroundColor Gray

    Write-Host "Creating $($category.Output)..." -ForegroundColor Cyan
    pandoc $files `
        -o $category.Output `
        --resource-path=".;.\Lectures;.\Seminars" `
        --pdf-engine=xelatex `
        -V geometry:a4paper,margin=1cm `
        -V mainfont="Cambria" `
        -V mathfont="Cambria Math" `
        -V monofont="Consolas" `
        -V pagestyle=empty `
        --from markdown+tex_math_single_backslash+tex_math_dollars-yaml_metadata_block

    if ($LASTEXITCODE -eq 0) {
        Write-Host "PDF created successfully: $($category.Output)" -ForegroundColor Green
        $file = Get-Item $category.Output
        Write-Host "Size: $([math]::Round($file.Length / 1KB, 1)) KB" -ForegroundColor Gray
    } else {
        Write-Host "Error creating $($category.Output)" -ForegroundColor Red
    }
}
