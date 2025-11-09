$ErrorActionPreference = "Stop"
$repoUrl = "https://github.com/Harley-PY/SimpleTaskList.git"
$appName = "simpletodo"
$installDir = "$env:USERPROFILE\.$appName"

Write-Host "🚀 Starting installation for $appName..."

function Install-Git {
    Write-Host "🔍 Checking for Git..."
    if (Get-Command git -ErrorAction SilentlyContinue) {
        Write-Host "✅ Git already installed."
    } else {
        Write-Host "⚙️ Installing Git..."
        Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/latest/download/Git-2.47.0-64-bit.exe" -OutFile "$env:TEMP\git-installer.exe"
        Start-Process "$env:TEMP\git-installer.exe" -ArgumentList "/VERYSILENT", "/NORESTART" -Wait
        Write-Host "✅ Git installed."
    }
}

function Install-Python {
    Write-Host "🔍 Checking for Python..."
    if (Get-Command python -ErrorAction SilentlyContinue) {
        Write-Host "✅ Python already installed."
    } else {
        Write-Host "⚙️ Installing Python..."
        Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.12.5/python-3.12.5-amd64.exe" -OutFile "$env:TEMP\python-installer.exe"
        Start-Process "$env:TEMP\python-installer.exe" -ArgumentList "/quiet", "InstallAllUsers=1", "PrependPath=1", "Include_test=0" -Wait
        Write-Host "✅ Python installed."
    }
}

Install-Git
Install-Python

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

# --- Run setup ---
python setup.py

# --- Add to PATH ---
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;$installDir", "User")
    Write-Host "✅ Added $appName to PATH."
}

Write-Host "`n🎉 Installation complete!"
Write-Host "➡️ Open a new terminal and run '$appName'"
