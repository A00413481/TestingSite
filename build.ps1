# Simple Build Script - Copies files to dist without minification
# Preserves readable source code while creating production folder

$SourceDir = "."
$DistDir = "dist"

# Remove existing dist if it exists
if (Test-Path $DistDir) {
    Remove-Item -Recurse -Force $DistDir
}

# Create dist directory
New-Item -ItemType Directory -Path $DistDir

# Copy all files except node_modules and dist
Get-ChildItem -Path $SourceDir -Exclude @("node_modules", "dist", ".git") | 
    Copy-Item -Destination $DistDir -Recurse -Force

Write-Host "Build complete! Files copied to $DistDir"
Write-Host "Your source files remain editable in the root folder."
Write-Host "Deploy from $DistDir for production."