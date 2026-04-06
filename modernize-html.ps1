# Modernize HTML Files Script - Updates head and JS sections for Bootstrap 5 and modern meta tags
# Run after updating index.html

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

# New head content (from updated index.html)
$NewHead = @'
    <!-- SEO Meta Tags -->
    <meta name="keywords" content="nonprofit health, preventive health, rehabilitation, senior preventive health, back and neck pain, chronic health conditions, health education, health advocacy, primary care support, preventive health framework, resistance band strength training, wellness, support our work, 501c3 nonprofit, health, organization">
    <meta name="description" content="Saving Lives Through Better Health. Providing innovative preventive health education and advocating for healthcare system change. We are a 501(c)3 preventive health nonprofit organization supporting primary care patients and public health.">
    <meta name="author" content="Preventive Health Initiative">
    
    <!-- Open Graph / Social Media Meta Tags -->
    <meta property="og:title" content="Preventive Health - Saving Lives Through Better Health">
    <meta property="og:description" content="Providing innovative preventive health education and advocating for healthcare system change.">
    <meta property="og:image" content="assets/images/logo/phi_logo.svg">
    <meta property="og:url" content="https://yourwebsite.com">
    <meta property="og:type" content="website">
    
    <!-- Favicon -->
    <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon">
    
    <title>Preventive Health - Saving Lives Through Better Health</title>
    
    <!-- Stylesheets -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/meanmenu.css">
    <link rel="stylesheet" href="assets/css/all.min.css">
    <link rel="stylesheet" href="assets/css/swiper-bundle.min.css">
    <link rel="stylesheet" href="assets/css/magnific-popup.css">
    <link rel="stylesheet" href="assets/css/animate.css">
    <link rel="stylesheet" href="assets/css/nice-select.css">
    <link rel="stylesheet" href="assets/css/style.css">
'@

# New JS content
$NewJS = @'
    <!-- Jquery 3. 7. 1 Min Js -->
    <script src="assets/js/jquery-3.7.1.min.js"></script>
    <!-- Bootstrap 5 bundle min Js -->
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <!-- Mean menu Js -->
    <script src="assets/js/meanmenu.js"></script>
    <!-- Swiper bundle min Js -->
    <script src="assets/js/swiper-bundle.min.js"></script>
    <!-- Counterup min Js -->
    <script src="assets/js/jquery.counterup.min.js"></script>
    <!-- Wow min Js -->
    <script src="assets/js/wow.min.js"></script>
    <!-- Magnific popup min Js -->
    <script src="assets/js/magnific-popup.min.js"></script>
    <!-- Nice select min Js -->
    <script src="assets/js/nice-select.min.js"></script>
    <!-- Waypoints Js -->
    <script src="assets/js/jquery.waypoints.js"></script>
    <!-- Script Js -->
    <script src="assets/js/script.js"></script>
'@

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
        
        # Replace head section (from <!-- Favicon img --> to <!-- Style css -->)
        $HeadPattern = '(?s)<!-- Favicon img -->.*<!-- Style css -->'
        $Content = [regex]::Replace($Content, $HeadPattern, "<!-- Favicon img -->`n$NewHead")
        
        # Replace JS section (from <!-- Jquery --> to <!-- Script Js -->)
        $JSPattern = '(?s)<!-- Jquery.*Min Js -->.*<!-- Script Js -->'
        $Content = [regex]::Replace($Content, $JSPattern, $NewJS)
        
        Set-Content -Path $PagePath -Value $Content -Encoding UTF8
        Write-Host "Modernized $Page"
        $UpdatedCount++
    } catch {
        Write-Error "Failed to update $Page`: $($_.Exception.Message)"
        $FailedCount++
    }
}

Write-Host "`nModernization complete!"
Write-Host "Updated: $UpdatedCount pages"
Write-Host "Failed: $FailedCount pages"