# Replace checkmark symbols with stylish Font Awesome bullet points
# Replaces âœ…&nbsp; with <i class="fas fa-check-circle text-primary me-2"></i>

$Files = @(
    "about.html",
    "health-education.html", 
    "teen-health.html",
    "senior-health.html"
)

foreach ($File in $Files) {
    $Path = Join-Path $PSScriptRoot $File
    if (Test-Path $Path) {
        $Content = Get-Content -Raw -Path $Path
        $Content = $Content -replace 'âœ…&nbsp;', '<i class="fas fa-check-circle text-primary me-2"></i>'
        Set-Content -Path $Path -Value $Content -Encoding UTF8
        Write-Host "Updated $File"
    }
}

Write-Host "All checkmarks replaced with stylish bullet points!"