# Add Playwright --allow-unrestricted-file-access to Claude Desktop config.
# Run this script through the paired .bat file.

$ErrorActionPreference = 'Stop'

function Find-ClaudeConfig {
    $candidates = @()

    if ($env:APPDATA) {
        $candidates += Join-Path $env:APPDATA "Claude\claude_desktop_config.json"
        $candidates += Join-Path $env:APPDATA "Claude-3p\claude_desktop_config.json"
    }

    $packageRoot = Join-Path $env:LOCALAPPDATA "Packages\Claude_pzs8sxrjxfjjc\LocalCache\Roaming"
    $candidates += Join-Path $packageRoot "Claude\claude_desktop_config.json"
    $candidates += Join-Path $packageRoot "Claude-3p\claude_desktop_config.json"

    $existing = $candidates | Where-Object { Test-Path -LiteralPath $_ }
    foreach ($path in $existing) {
        $raw = Get-Content -LiteralPath $path -Raw -Encoding UTF8
        try {
            $config = $raw | ConvertFrom-Json
        } catch {
            continue
        }

        if ($config.mcpServers -and $config.mcpServers.playwright) {
            return $path
        }
    }

    if ($existing.Count -gt 0) {
        return $existing[0]
    }

    return $null
}

$configPath = Find-ClaudeConfig

Write-Host ""
Write-Host "=== Patch Claude Desktop Playwright config ==="
Write-Host ""
Write-Host "Searching Claude Desktop config..."
Write-Host ""

if (-not $configPath) {
    Write-Host "X Claude Desktop config not found"
    Write-Host "  Please confirm Claude Desktop is installed"
    exit 1
}

Write-Host "Target: $configPath"
Write-Host ""

# Backup
$backup = "$configPath.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item -LiteralPath $configPath -Destination $backup
Write-Host "v Backup: $backup"

# Read and parse
$raw = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8
$config = $raw | ConvertFrom-Json

# Find playwright server
if (-not $config.mcpServers) {
    Write-Host "X config has no mcpServers"
    exit 1
}

if (-not $config.mcpServers.playwright) {
    Write-Host "X config has no playwright server"
    exit 1
}

$pw = $config.mcpServers.playwright
Write-Host ""
Write-Host "Current args:"
$pw.args | ForEach-Object { Write-Host "  - $_" }

# Check flag
$flag = "--allow-unrestricted-file-access"
if ($pw.args -contains $flag) {
    Write-Host ""
    Write-Host "v Flag already exists: $flag"
    exit 0
}

# Add flag to args
$pw.args = $pw.args + $flag

# Write back
$newRaw = $config | ConvertTo-Json -Depth 20
[System.IO.File]::WriteAllText($configPath, $newRaw, (New-Object System.Text.UTF8Encoding $false))

Write-Host ""
Write-Host "v Patched. New args:"
$pw.args | ForEach-Object { Write-Host "  - $_" }
Write-Host ""
Write-Host "=== Next steps ==="
Write-Host "1. Fully quit Claude Desktop / Cowork from the system tray"
Write-Host "2. Open Claude Desktop / Cowork again"
Write-Host "3. Tell Codex: config patched and restarted"
Write-Host ""
Write-Host "After restart, Playwright can upload files directly from the project path."
Write-Host ""
exit 0
