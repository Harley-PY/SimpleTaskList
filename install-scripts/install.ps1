$ErrorActionPreference = "Stop"
$repoUrl = "https://github.com/Harley-PY/SimpleTaskList.git"
$appName = "simpletodo"
$installDir = "$env:USERPROFILE\.$appName"

function Install-Python {
    Write-Host "🐍 Checking for Python..."
    if (Get-Command python -ErrorAction SilentlyContinue) {
        Write-Host "✅ Python already installed."
        return
    }
    Write-Host "⚙️ Installing Python..."
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.14.0/python-3.14.0-amd64.exe" -OutFile "$env:TEMP\python-installer.exe"
    Start-Process "$env:TEMP\python-installer.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0" -Wait
    Write-Host "✅ Python installed and added to PATH."
}

# --- Clone or update repo ---
if (Test-Path $installDir) {
    Write-Host "📦 Updating $appName..."
    Set-Location $installDir
    git pull | Out-Null
} else {
    Write-Host "⬇️ Cloning $appName..."
    git clone $repoUrl $installDir
    Set-Location $installDir
}

# --- Ensure Python installed ---
Install-Python

# --- Run setup ---
python setup.py

# --- Add to PATH ---
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;$installDir", "User")
    Write-Host "✅ Added $appName to PATH."
}

Write-Host "`n🎉 Installation complete! Open a new terminal and run '$appName'."
