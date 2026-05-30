$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$proj = Join-Path $root "images\projects"

$portfolioSrc = Join-Path $env:LOCALAPPDATA "Temp\cursor\screenshots\portfolio-hero-capture.jpg"
$oakViewportJson = Join-Path $env:USERPROFILE ".cursor\browser-logs\cdp-response-Page.captureScreenshot-2026-05-30T14-14-11-584Z.json"

if (-not (Test-Path $portfolioSrc)) {
  throw "Missing portfolio capture at $portfolioSrc"
}

Copy-Item $portfolioSrc (Join-Path $proj "portfolio-raw.jpg") -Force

if (Test-Path $oakViewportJson) {
  & (Join-Path $PSScriptRoot "save-cdp-screenshot.ps1") `
    -JsonPath $oakViewportJson `
    -OutputPath (Join-Path $proj "oak-viewport-raw.jpg")
} else {
  $oakSrc = Join-Path $env:LOCALAPPDATA "Temp\cursor\screenshots\oak-hero-capture.jpg"
  if (-not (Test-Path $oakSrc)) { throw "Missing oak capture" }
  Copy-Item $oakSrc (Join-Path $proj "oak-viewport-raw.jpg") -Force
}

& (Join-Path $PSScriptRoot "capture-project-shot.ps1") `
  -InputPath (Join-Path $proj "portfolio-raw.jpg") `
  -OutputPath (Join-Path $proj "portfolio-screenshot.jpg")

$oakSrc = Join-Path $env:LOCALAPPDATA "Temp\cursor\screenshots\oak-hero-capture.jpg"
if (-not (Test-Path $oakSrc)) { $oakSrc = Join-Path $proj "oak-raw.jpg" }
Copy-Item $oakSrc (Join-Path $proj "oak-raw.jpg") -Force
& (Join-Path $PSScriptRoot "capture-project-shot.ps1") `
  -InputPath (Join-Path $proj "oak-raw.jpg") `
  -OutputPath (Join-Path $proj "oak-street-screenshot.jpg") `
  -Focus left

Get-ChildItem $proj -Filter "*.jpg" | Select-Object Name, Length, LastWriteTime
