Add-Type -AssemblyName System.Drawing

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$out = Join-Path $root "images\og-image.jpg"
$photoPath = Join-Path $root "images\genrei-profile.jpg"

function Get-Font([float]$size, [switch]$Bold) {
  $base = New-Object System.Drawing.Font("Segoe UI", $size)
  if ($Bold) {
    return New-Object System.Drawing.Font($base, [System.Drawing.FontStyle]::Bold)
  }
  $base
}

function Save-Jpeg($bitmap, $path) {
  $enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
    Where-Object { $_.MimeType -eq "image/jpeg" }
  $ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality, 92L)
  $bitmap.Save($path, $enc, $ep)
  $bitmap.Dispose()
}

$w = 1200
$h = 630
$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$g.Clear([System.Drawing.Color]::FromArgb(248, 250, 252))

$brushBg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  (New-Object System.Drawing.Rectangle 0, 0, $w, $h),
  [System.Drawing.Color]::FromArgb(241, 245, 249),
  [System.Drawing.Color]::FromArgb(204, 251, 241),
  35)
$g.FillRectangle($brushBg, 0, 0, $w, $h)

$card = [System.Drawing.Rectangle]::FromLTRB(56, 56, $w - 56, $h - 56)
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$radius = 28
$path.AddArc($card.X, $card.Y, $radius, $radius, 180, 90)
$path.AddArc($card.Right - $radius, $card.Y, $radius, $radius, 270, 90)
$path.AddArc($card.Right - $radius, $card.Bottom - $radius, $radius, $radius, 0, 90)
$path.AddArc($card.X, $card.Bottom - $radius, $radius, $radius, 90, 90)
$path.CloseFigure()
$g.FillPath([System.Drawing.Brushes]::White, $path)
$g.DrawPath((New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(226, 232, 240), 2)), $path)

$photoX = 96
$photoY = 118
$photoW = 220
$photoH = 294

if (Test-Path $photoPath) {
  $photo = [System.Drawing.Image]::FromFile($photoPath)
  $g.DrawImage($photo, $photoX, $photoY, $photoW, $photoH)
  $photo.Dispose()
} else {
  $g.FillRectangle(
    (New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(15, 118, 110))),
    $photoX,
    $photoY,
    $photoW,
    $photoH)
  $g.DrawString("GV", (Get-Font 72 -Bold), [System.Drawing.Brushes]::White, 155, 230)
}

$ink = [System.Drawing.Color]::FromArgb(15, 23, 42)
$muted = [System.Drawing.Color]::FromArgb(71, 85, 105)
$accent = [System.Drawing.Color]::FromArgb(15, 118, 110)

$g.DrawString("Genrei G. Vargas", (Get-Font 52 -Bold), (New-Object System.Drawing.SolidBrush $ink), 360, 150)
$g.DrawString(
  "Digital operations & frontend support",
  (Get-Font 28),
  (New-Object System.Drawing.SolidBrush $muted),
  360,
  220)
$g.DrawString(
  "VA | Data entry | Admin | Web (HTML, CSS, JS)",
  (Get-Font 22),
  (New-Object System.Drawing.SolidBrush $accent),
  360,
  280)
$g.DrawString(
  "BS IT | STI San Jose Del Monte | Open to remote",
  (Get-Font 20),
  (New-Object System.Drawing.SolidBrush $muted),
  360,
  340)

$badgeRect = [System.Drawing.Rectangle]::FromLTRB(360, 400, 560, 448)
$g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(236, 253, 245))), $badgeRect)
$g.DrawRectangle((New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(16, 185, 129), 1)), $badgeRect)
$g.DrawString("Open to work", (Get-Font 18 -Bold), (New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(6, 95, 70))), 388, 412)

$g.DrawString("icygen.github.io/WebPortfolio", (Get-Font 18), (New-Object System.Drawing.SolidBrush $accent), 360, 490)

$g.Dispose()
Save-Jpeg $bmp $out
Write-Host "Saved $out"
