# Add Skip Link for Accessibility Script
# Adds a skip to main content link to all HTML files

$ProjectRoot = $PSScriptRoot

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

$SkipLink = '<a href="#main-content" class="sr-only sr-only-focusable">Skip to main content</a>'

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
        $Content = Get-Content -Raw -Path $PagePath
        
        # Add skip link after <body>
        $Content = [regex]::Replace($Content, '<body>', "<body>`n    $SkipLink")
        
        # Ensure main has id
        if ($Content -notmatch '<main') {
            # If no main, add id to first section or something, but assume main exists
        } else {
            $Content = [regex]::Replace($Content, '<main', '<main id="main-content"')
        }
        
        Set-Content -Path $PagePath -Value $Content -Encoding UTF8
        Write-Host "Added skip link to $Page"
        $UpdatedCount++
    } catch {
        Write-Error "Failed to update $Page`: $($_.Exception.Message)"
        $FailedCount++
    }
}

Write-Host "`nSkip link addition complete!"
Write-Host "Updated: $UpdatedCount pages"
Write-Host "Failed: $FailedCount pages"