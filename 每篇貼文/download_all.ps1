$base = Split-Path -Parent $MyInvocation.MyCommand.Path

$urls = @{
  "2026-08-06_第33篇_十輪品" = @(
    "6r8CiSbWw04C14zA","YcBu1gsz5e1WOzqK","XhYMb9eGexHUTjnE","MPgQUqJAorHs2zja",
    "ubmcJzOTufJNsHVE","8EReZFbkWcAxR3pD","NTBfE5UUpr2YAVIp","WOHM47mCzt1Ywu2p",
    "ctDI4DKDz7FF6KNo","YahKQHSjWaH2rVvs","1m0MsOKLOy1U66Rx","WOpSFLWsOKIQ0Uha"
  )
  "2026-08-07_第34篇_十輪品" = @(
    "3bdafb2FzYIEFqSk","e6TAFUNk7T3W3aYl","1IboA6rSN2FNhZF7","4GDIQbJU9cF15l7G",
    "xcVTVCAe5K3OAjqX","6bBry2MEWM6yAO6p","2HyN52f48gJ0UZsy","2WP2orRjisAsNjCQ",
    "eNhb0N1NZgHLLlV8","fqUVP5uWCoDTRtWk","5DC0NrmK4iFqL6QQ","3Jj4Y42r1rGzNRv8"
  )
  "2026-08-10_第35篇_十輪品" = @(
    "RteBWwevsRFGAkvY","X6AfQJJmfp1YLCaQ","4AZUugmGFQEJH22A","ZS0052PfD5IhZlWc",
    "oAT19J7wYg7uO24I","cbtGoo2vqO1l4gxC","8lrufXhjcK8ZF2bc","CWs5ozjxo94mxsxP",
    "SYCkLU7e3mKF1UG9","saN5JinOoqIQWILV","6CVSDkAzb4AmrDKr","15l44rpNo4JAypi9"
  )
  "2026-08-11_第36篇_十輪品" = @(
    "slAX9gUwF5Ew0Jj9","3BPBt5FCYvHMT19X","hiI3oJWlHe5ems72","hYbseg1KBjEt5BYN",
    "2Fnq8G6JU7LO7TxW","NXvp05EgqrKRrpMl","E3gDCfIMYt3AXcKI","RAvgRqeobC7nvCPd",
    "gRKe0SyouAFOvJld","aX40LUY2cH3qnE7d","JD89vSdO3b15nrva","xERT6GbXyx9MAab5"
  )
  "2026-08-12_第37篇_十輪品" = @(
    "UYa4cJpEvA6n9i9a","oyg7TAbhfFIAfhWg","y83fEzrd2dA38fmh","687QOPEO1D6W6Ugo",
    "8THDTUSTIV4vV5n2","EteSVAlPRUGSBB62","4GWOBir7p0AvPlSD","86v0vm1jhBFVKB3Z",
    "eAkLhDbiexLtaEM0","b7f7g0e6FMCzk7Gf","b524Vsdkgf1tNkSL","fZHndJG5Wj51gVvq"
  )
  "2026-08-13_第38篇_十輪品" = @(
    "0eCf2uIzY35BOUTH","3lF56PPM35GkntWn","uK9P6a5dmG7fsWGa","3HQPbswU1j7eedO3",
    "T6N8k7GUrYDNh4ey","g2X8fhTtbeLOZ6Ee","DzmDUIdZ7N5U5EZB","XXBBKE7uE7JWlvSh",
    "pOvOt72cfK8o3wLB","WWZOhek6nDJfv3Uo","kjBeLrFtXv3pFxTU","21kmAOZoDXBkIS19"
  )
}

$ok = 0; $fail = 0
foreach ($folder in $urls.Keys | Sort-Object) {
  $dir = Join-Path $base "$folder\圖片"
  Write-Host "`n--- $folder ---" -ForegroundColor Cyan
  $ids = $urls[$folder]
  for ($i = 0; $i -lt $ids.Count; $i++) {
    $num = "{0:D2}" -f ($i + 1)
    $out = Join-Path $dir "$num.png"
    $url = "https://a.lovart.ai/artifacts/agent/$($ids[$i]).png"
    try {
      Invoke-WebRequest -Uri $url -OutFile $out -ErrorAction Stop
      Write-Host "  [OK] $num" -ForegroundColor Green
      $ok++
    } catch {
      Write-Host "  [FAIL] $num - $_" -ForegroundColor Red
      $fail++
    }
  }
}
Write-Host "`n============================================" -ForegroundColor Yellow
Write-Host "  Done! OK=$ok  FAIL=$fail  Total=72" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
