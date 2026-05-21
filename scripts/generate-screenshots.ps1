Add-Type -AssemblyName System.Drawing

$outDir = Join-Path $PSScriptRoot "..\images\projects"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

function Save-Jpeg($bitmap, $path) {
  $enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
    Where-Object { $_.MimeType -eq "image/jpeg" }
  $ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality, 92L)
  $bitmap.Save($path, $enc, $ep)
  $bitmap.Dispose()
}

function Get-Font([float]$size, [switch]$Bold) {
  $base = New-Object System.Drawing.Font("Segoe UI", $size)
  if ($Bold) {
    return New-Object System.Drawing.Font($base, [System.Drawing.FontStyle]::Bold)
  }
  $base
}

function Draw-PortfolioShot {
  $w = 1280; $h = 800
  $bmp = New-Object System.Drawing.Bitmap $w, $h
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
  $g.Clear([System.Drawing.Color]::FromArgb(248, 250, 252))

  $chrome = [System.Drawing.Color]::FromArgb(30, 41, 59)
  $accent = [System.Drawing.Color]::FromArgb(15, 118, 110)
  $white = [System.Drawing.Color]::White
  $muted = [System.Drawing.Color]::FromArgb(71, 85, 105)
  $ink = [System.Drawing.Color]::FromArgb(15, 23, 42)

  $g.FillRectangle((New-Object System.Drawing.SolidBrush $chrome), 0, 0, $w, 44)
  $g.FillEllipse([System.Drawing.Brushes]::IndianRed, 16, 16, 12, 12)
  $g.FillEllipse([System.Drawing.Brushes]::Gold, 34, 16, 12, 12)
  $g.FillEllipse([System.Drawing.Brushes]::LightGreen, 52, 16, 12, 12)
  $g.DrawString(
    "icygen.github.io/WebPortfolio/",
    (Get-Font 9),
    [System.Drawing.Brushes]::LightGray,
    100,
    15)

  $g.FillRectangle((New-Object System.Drawing.SolidBrush $white), 0, 44, $w, $h - 44)
  $g.FillRectangle(
    (New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(241, 245, 249))),
    0,
    44,
    $w,
    220)

  $g.DrawString("Genrei G. Vargas", (Get-Font 28 -Bold), (New-Object System.Drawing.SolidBrush $ink), 80, 95)
  $g.DrawString(
    "Digital operations & frontend support",
    (Get-Font 11),
    (New-Object System.Drawing.SolidBrush $muted),
    80,
    150)

  $g.FillRectangle((New-Object System.Drawing.SolidBrush $accent), 80, 195, 150, 38)
  $g.DrawString("Download Resume", (Get-Font 10 -Bold), [System.Drawing.Brushes]::White, 98, 205)

  $g.FillRectangle((New-Object System.Drawing.SolidBrush $white), 720, 90, 480, 300)
  $g.DrawRectangle(
    (New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(226, 232, 240))),
    720,
    90,
    480,
    300)
  $g.DrawString("Get in touch", (Get-Font 12 -Bold), (New-Object System.Drawing.SolidBrush $ink), 750, 115)
  $g.DrawString("reiv728@gmail.com", (Get-Font 10), (New-Object System.Drawing.SolidBrush $muted), 750, 150)
  $g.DrawString("+63 956 957 0555", (Get-Font 10), (New-Object System.Drawing.SolidBrush $muted), 750, 175)

  $g.FillRectangle(
    (New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(248, 250, 252))),
    80,
    300,
    200,
    100)
  $g.DrawString("About", (Get-Font 14 -Bold), (New-Object System.Drawing.SolidBrush $ink), 100, 330)
  $g.FillRectangle(
    (New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(248, 250, 252))),
    300,
    300,
    200,
    100)
  $g.DrawString("Services", (Get-Font 14 -Bold), (New-Object System.Drawing.SolidBrush $muted), 320, 330)

  $g.Dispose()
  Save-Jpeg $bmp (Join-Path $outDir "portfolio-screenshot.jpg")
}

function Draw-CounterShot {
  $w = 1280; $h = 800
  $bmp = New-Object System.Drawing.Bitmap $w, $h
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
  $g.Clear([System.Drawing.Color]::FromArgb(15, 23, 42))

  $g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(30, 41, 59))), 0, 0, $w, 44)
  $g.FillEllipse([System.Drawing.Brushes]::IndianRed, 16, 16, 12, 12)
  $g.FillEllipse([System.Drawing.Brushes]::Gold, 34, 16, 12, 12)
  $g.FillEllipse([System.Drawing.Brushes]::LightGreen, 52, 16, 12, 12)
  $g.DrawString("file:/// ... /js-counter/", (Get-Font 9), [System.Drawing.Brushes]::LightGray, 100, 15)

  $card = [System.Drawing.Color]::FromArgb(30, 41, 59)
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $card), 440, 180, 400, 340)
  $g.DrawString("Simple Counter", (Get-Font 14), [System.Drawing.Brushes]::LightGray, 560, 220)
  $g.DrawString("42", (Get-Font 64 -Bold), [System.Drawing.Brushes]::White, 575, 275)

  $g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(239, 68, 68))), 480, 400, 90, 44)
  $g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(71, 85, 105))), 590, 400, 90, 44)
  $g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(15, 118, 110))), 700, 400, 90, 44)
  $g.DrawString("-", (Get-Font 16 -Bold), [System.Drawing.Brushes]::White, 515, 410)
  $g.DrawString("Reset", (Get-Font 10 -Bold), [System.Drawing.Brushes]::White, 605, 412)
  $g.DrawString("+", (Get-Font 16 -Bold), [System.Drawing.Brushes]::White, 735, 410)

  $g.Dispose()
  Save-Jpeg $bmp (Join-Path $outDir "js-counter-screenshot.jpg")
}

Draw-PortfolioShot
Draw-CounterShot
Write-Host "Screenshots saved to $outDir"
