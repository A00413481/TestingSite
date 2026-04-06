# Add Lazy Loading to Images Script
# Adds loading="lazy" to all <img> tags in HTML files for performance

$ProjectRoot = $PSScriptRoot

# Get all HTML files
$HtmlFiles = Get-ChildItem -Path $ProjectRoot -Filter "*.html" -Recurse

$UpdatedCount = 0
$FailedCount = 0

foreach ($File in $HtmlFiles) {
    try {
        $Content = Get-Content -Raw -Path $File.FullName
        
        $OriginalContent = $Content
        
        # Add loading="lazy" to img tags that don't already have it
        $Content = [regex]::Replace($Content, '<img([^>]*?)>', {
            param($match)
            $attrs = $match.Groups[1].Value
            if ($attrs -notmatch 'loading=') {
                '<img loading="lazy"' + $attrs + '>'
            } else {
                $match.Value
            }
        })
        
        if ($Content -ne $OriginalContent) {
            Set-Content -Path $File.FullName -Value $Content -Encoding UTF8
            Write-Host "Added lazy loading to images in $($File.Name)"
            $UpdatedCount++
        } else {
            Write-Host "No changes needed for $($File.Name)"
        }
    } catch {
        Write-Error "Failed to process $($File.Name): $($_.Exception.Message)"
        $FailedCount++
    }
}

Write-Host "`nLazy loading addition complete!"
Write-Host "Updated: $UpdatedCount files"
Write-Host "Failed: $FailedCount files"