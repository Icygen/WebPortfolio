param(
  [Parameter(Mandatory = $true)][string]$InputPath,
  [Parameter(Mandatory = $true)][string]$OutputPath,
  [int]$Width = 1280,
  [int]$Height = 800
)

Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Image]::FromFile((Resolve-Path $InputPath))
$bmp = New-Object System.Drawing.Bitmap $Width, $Height
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

$srcRatio = $src.Width / $src.Height
$destRatio = $Width / $Height

if ($srcRatio -gt $destRatio) {
  $newH = $src.Height
  $newW = [int]($src.Height * $destRatio)
  $x = [int](($src.Width - $newW) / 2)
  $y = 0
} else {
  $newW = $src.Width
  $newH = [int]($src.Width / $destRatio)
  $x = 0
  $y = 0
}

$dest = New-Object System.Drawing.Rectangle 0, 0, $Width, $Height
$srcRect = New-Object System.Drawing.Rectangle $x, $y, $newW, $newH
$g.DrawImage($src, $dest, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$src.Dispose()

$enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
  Where-Object { $_.MimeType -eq "image/jpeg" }
$ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
  [System.Drawing.Imaging.Encoder]::Quality, 90L)
$bmp.Save((Resolve-Path $OutputPath), $enc, $ep)
$bmp.Dispose()
Write-Host "Saved $OutputPath"
