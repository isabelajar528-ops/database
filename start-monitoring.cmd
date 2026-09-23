@echo off
setlocal
title NOC Lemhannas

set "KUMA_DIR=C:\laragon\www\uptime-kuma"
set "KUMA_URL=http://localhost:3001"
set "NOC_URL=http://localhost:3001/noc"

echo Memeriksa NOC Lemhannas...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$c=Get-NetTCPConnection -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue; if (-not $c) { Start-Process cmd.exe -ArgumentList '/k','cd /d C:\laragon\www\uptime-kuma ^&^& npm start' -WorkingDirectory 'C:\laragon\www\uptime-kuma'; exit 10 }"
if errorlevel 10 (
    echo Server baru dijalankan. Menunggu sampai siap...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "for($i=0;$i -lt 30;$i++){try{$r=Invoke-WebRequest -Uri '%KUMA_URL%/dashboard' -UseBasicParsing -TimeoutSec 1; if($r.StatusCode -ge 200){exit 0}}catch{}; Start-Sleep -Seconds 1}; exit 1"
    if errorlevel 1 (
        echo Gagal menunggu NOC Lemhannas pada port 3001.
        pause
        exit /b 1
    )
) else (
    echo NOC Lemhannas sudah aktif. Tidak menjalankan instance kedua.
)

echo Membuka NOC Lemhannas...
start "" "%NOC_URL%"
exit /b 0
