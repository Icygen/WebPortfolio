param([int]$Port = 8765)

$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:$Port/")
$listener.Start()
Write-Host "Serving $root at http://127.0.0.1:$Port/ (Ctrl+C to stop)"

$mime = @{
  ".html" = "text/html; charset=utf-8"
  ".htm"  = "text/html; charset=utf-8"
  ".css"  = "text/css; charset=utf-8"
  ".js"   = "application/javascript; charset=utf-8"
  ".json" = "application/json; charset=utf-8"
  ".svg"  = "image/svg+xml"
  ".png"  = "image/png"
  ".jpg"  = "image/jpeg"
  ".jpeg" = "image/jpeg"
  ".webp" = "image/webp"
  ".ico"  = "image/x-icon"
  ".pdf"  = "application/pdf"
}

while ($listener.IsListening) {
  $context = $listener.GetContext()
  $request = $context.Request
  $response = $context.Response

  try {
    $path = [System.Uri]::UnescapeDataString($request.Url.LocalPath.TrimStart("/"))
    if ([string]::IsNullOrWhiteSpace($path)) { $path = "index.html" }
    $full = Join-Path $root ($path -replace "/", [IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path $full -PathType Leaf)) {
      if (Test-Path ($full + ".html") -PathType Leaf) {
        $full = $full + ".html"
      } else {
        $response.StatusCode = 404
        $bytes = [Text.Encoding]::UTF8.GetBytes("Not found")
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
        $response.Close()
        continue
      }
    }

    $ext = [IO.Path]::GetExtension($full).ToLowerInvariant()
    if ($mime.ContainsKey($ext)) {
      $response.ContentType = $mime[$ext]
    }
    $data = [IO.File]::ReadAllBytes($full)
    $response.StatusCode = 200
    $response.ContentLength64 = $data.Length
    $response.OutputStream.Write($data, 0, $data.Length)
  } catch {
    $response.StatusCode = 500
  } finally {
    $response.Close()
  }
}
