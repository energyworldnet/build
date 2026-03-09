Param (
  [switch]$SkipWinget
)

$ErrorActionPreference = "Stop"

Function Update-SessionEnvironment {
  # Adapted from StackOverflow:
  # https://stackoverflow.com/a/31845512/1409101
  $env:Path = `
    [System.Environment]::GetEnvironmentVariable("Path", "Machine") + `
    ";" + `
    [System.Environment]::GetEnvironmentVariable("Path", "User")
}

If (-Not $SkipWinget) {
  $Principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
  If ($Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Do not run this script as an administrator. Close this window and try again."
    Exit 1
  }

  Write-Host "Configuring Windows..." -ForegroundColor Cyan
  winget configure -f winget.yaml --suppress-initial-details --accept-configuration-agreements
  If ($LASTEXITCODE -Ne 0) {
    Write-Error "Failed to configure Windows. Try running the script again."
    Exit $LASTEXITCODE
  }

  Update-SessionEnvironment
}

Write-Host "Installing pnpm packages..." -ForegroundColor Cyan
pnpm install --frozen-lockfile

Write-Host "Installing Python packages..." -ForegroundColor Cyan
py -m pip install -r requirements.txt

Write-Host "Installing pre-commit hooks..." -ForegroundColor Cyan
pre-commit install --install-hooks --overwrite

Write-Host "Done! You're good to go." -ForegroundColor Green
