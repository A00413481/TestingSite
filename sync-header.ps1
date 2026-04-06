# Header Sync Script - Updates all pages with current header from includes/header.html
# Usage: Run this script whenever you change the header in includes/header.html

$HeaderFile = "includes/header.html"
$ProjectRoot = $PSScriptRoot

# Check if header file exists
if (-not (Test-Path $HeaderFile)) {
    Write-Error "Header file not found: $HeaderFile"
    exit 1
}

# Read the header content
$HeaderContent = Get-Content -Raw -Path $HeaderFile

# Define pages to update
$Pages = @(
    "index.html",
    "about.html",
    "contact.html",
    "donation-information.html",
    "error.html",
    "exercise-education.html",
    "framework.html",
    "health-education.html",
    "health-messaging.html",
    "health-system-change.html",
    "nutrition-education.html",
    "senior-health.html",
    "teen-health.html"
)

$UpdatedCount = 0
$FailedCount = 0

foreach ($Page in $Pages) {
    $PagePath = Join-Path $ProjectRoot $Page
    
    if (-not (Test-Path $PagePath)) {
        Write-Warning "Page not found: $Page"
        $FailedCount++
        continue
    }
    
    try {
        $PageContent = Get-Content -Raw -Path $PagePath
        
        # Replace the header section using regex
        # Match from <!-- Top header area start here --> to <!-- Sidebar area end here -->
        $NewContent = [regex]::Replace(
            $PageContent,
            '(?s)<!-- Top header area start here -->.*?<!-- Sidebar area end here -->',
            $HeaderContent
        )
        
        # Write back if changed
        if ($NewContent -ne $PageContent) {
            Set-Content -Path $PagePath -Value $NewContent -Encoding UTF8
            Write-Host "✓ Updated: $Page"
            $UpdatedCount++
        } else {
            Write-Host "- No changes needed: $Page"
        }
    }
    catch {
        Write-Error "Failed to update $Page : $_"
        $FailedCount++
    }
}

Write-Host "`nSummary:"
Write-Host "  Updated: $UpdatedCount pages"
Write-Host "  Failed: $FailedCount pages"

if ($FailedCount -eq 0) {
    Write-Host "`n✓ Header sync complete!"
} else {
    Write-Host "`n⚠ Header sync completed with errors"
}
