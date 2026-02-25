Param(
  [int]$Port = 8000,
  [string]$Root = "c:\Users\mmad5\OneDrive\Desktop\Mohamed"
)
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serving on http://localhost:$Port/ (Ctrl+C to stop)"
while ($true) {
  $ctx = $listener.GetContext()
  $rel = $ctx.Request.Url.AbsolutePath.TrimStart('/')
  if ($rel -eq "") { $rel = "index.html" }
  $path = Join-Path $Root $rel
  if (-not (Test-Path $path)) { $path = Join-Path $Root "index.html" }
  $ext = [IO.Path]::GetExtension($path).ToLower()
  $ct = "text/html"
  switch ($ext) {
    ".css"   { $ct = "text/css" }
    ".js"    { $ct = "application/javascript" }
    ".svg"   { $ct = "image/svg+xml" }
    ".png"   { $ct = "image/png" }
    ".jpg"   { $ct = "image/jpeg" }
    ".jpeg"  { $ct = "image/jpeg" }
    default  { $ct = "text/html" }
  }
  try {
    $bytes = [IO.File]::ReadAllBytes($path)
    $ctx.Response.ContentType = $ct
    $ctx.Response.ContentLength64 = $bytes.Length
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } catch {
    $ctx.Response.StatusCode = 404
    $msg = [Text.Encoding]::UTF8.GetBytes("Not Found")
    $ctx.Response.OutputStream.Write($msg, 0, $msg.Length)
  }
  $ctx.Response.OutputStream.Close()
}
