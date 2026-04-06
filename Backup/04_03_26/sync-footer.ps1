# Footer Sync Script - Updates all pages with current footer from includes/footer.html
# Usage: Run this script whenever you change the footer in includes/footer.html

$FooterFile = "includes/footer.html"
$ProjectRoot = $PSScriptRoot

# Check if footer file exists
if (-not (Test-Path $FooterFile)) {
    Write-Error "Footer file not found: $FooterFile"
    exit 1
}

# Read the footer content
$FooterContent = Get-Content -Raw -Path $FooterFile

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
        
        # Replace the footer section using regex
        # Match from <!-- Footer area start here --> to <!-- Footer area end here -->
        $Pattern = '(?s)<!-- Footer area start here -->.*<!-- Footer area end here -->'
        $Replacement = "<!-- Footer area start here -->`n$FooterContent`n<!-- Footer area end here -->"
        
        $NewContent = [regex]::Replace($PageContent, $Pattern, $Replacement)
        
        if ($NewContent -ne $PageContent) {
            Set-Content -Path $PagePath -Value $NewContent -Encoding UTF8
            Write-Host "Updated footer in $Page"
            $UpdatedCount++
        } else {
            Write-Host "No changes needed for $Page"
        }
    } catch {
        Write-Error "Failed to update $Page`: $($_.Exception.Message)"
        $FailedCount++
    }
}

Write-Host "`nFooter sync complete!"
Write-Host "Updated: $UpdatedCount pages"
Write-Host "Failed: $FailedCount pages"