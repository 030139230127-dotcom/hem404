@echo off
chcp 65001 >nul
cd /d "%~dp0"
where python >nul 2>&1
if errorlevel 1 (
 echo Python chua cai hoac khong co trong PATH.
 echo Ban co the mo index.html de choi thu, hoac cai Python 3 tu python.org.
 pause
 exit /b 1
)
start "HEM404 LOCAL WEB SERVER" /min cmd /k "python -m http.server 8000"
timeout /t 2 /nobreak >nul
start "" "http://localhost:8000"
echo Neu trang khong mo, truy cap http://localhost:8000
