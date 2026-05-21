$dir = Join-Path $PSScriptRoot "..\images\icons"
$colors = @{
  "html5.svg"           = "#E34F26"
  "css3.svg"            = "#1572B6"
  "javascript.svg"      = "#F7DF1E"
  "canva.svg"           = "#00C4CC"
  "chatgpt.svg"         = "#10A37F"
  "excel.svg"           = "#217346"
  "word.svg"            = "#2B579A"
  "powerpoint.svg"      = "#D24726"
  "onedrive.svg"        = "#0078D4"
  "google.svg"          = "#4285F4"
  "gmail.svg"           = "#EA4335"
  "google-drive.svg"    = "#4285F4"
  "google-chat.svg"     = "#34A853"
  "google-meet.svg"     = "#00897B"
  "google-forms.svg"    = "#7248B9"
  "google-calendar.svg" = "#4285F4"
  "zoom.svg"            = "#2D8CFF"
  "trello.svg"          = "#0052CC"
  "dropbox.svg"         = "#0061FF"
  "vscode.svg"          = "#007ACC"
  "github.svg"          = "#181717"
  "teams.svg"           = "#6264A7"
  "notion.svg"          = "#000000"
  "facebook.svg"        = "#0866FF"
  "tiktok.svg"          = "#000000"
  "instagram.svg"       = "#E4405F"
  "linkedin.svg"        = "#0A66C2"
  "threads.svg"         = "#000000"
  "pinterest.svg"       = "#BD081C"
}
$slackFills = @("#E01E5A", "#E01E5A", "#36C5F0", "#36C5F0", "#2EB67D", "#2EB67D", "#ECB22E", "#ECB22E")

foreach ($entry in $colors.GetEnumerator()) {
  $file = Join-Path $dir $entry.Key
  if (-not (Test-Path $file)) { Write-Host "Skip $($entry.Key)"; continue }

  $content = Get-Content $file -Raw
  $content = $content -replace ' fill="[^"]*"', ''

  if ($entry.Key -eq "slack.svg") {
    $i = 0
    $content = [regex]::Replace($content, '<path ', {
      param($match)
      $fill = $slackFills[$script:i]
      $script:i++
      return "<path fill=`"$fill`" "
    })
  }
  else {
    $hex = $entry.Value
    $content = $content -replace '<path ', "<path fill=`"$hex`" "
  }

  [System.IO.File]::WriteAllText($file, $content.Trim())
  Write-Host "OK $($entry.Key)"
}
