param(
  [Parameter(Mandatory = $true)][string]$JsonPath,
  [Parameter(Mandatory = $true)][string]$OutputPath
)
$json = Get-Content -Raw -LiteralPath $JsonPath | ConvertFrom-Json
$b64 = if ($json.result.data) { $json.result.data } else { $json.data }
$out = [IO.Path]::GetFullPath($OutputPath)
$dir = [IO.Path]::GetDirectoryName($out)
if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
[IO.File]::WriteAllBytes($out, [Convert]::FromBase64String($b64))
Write-Host "Wrote $OutputPath"
