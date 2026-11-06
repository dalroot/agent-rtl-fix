@echo off
title Agent RTL Fix - Universal BiDi Setup
echo ==========================================================
echo Running Agent RTL Fix Setup for Windows...
echo ==========================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
echo.
echo Setup finished! Press any key to exit.
pause >nul
