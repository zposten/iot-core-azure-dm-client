@echo off
set Version=44.0.3.1

@if "%1"=="" goto MissingParameters

@if "%1"=="Debug" goto BuildDebug
NuGet.exe pack "IoTDMClientLib.nuspec" -Prop Version=%Version% -Prop Flavor=%1
goto End

:BuildDebug
NuGet.exe pack "IoTDMClientLib.debug.nuspec" -Prop Version=%Version% -Prop Flavor=Debug
goto End

:MissingParameters
@echo.
@echo Usage:
@echo     PackIoTDMClientLib.cmd flavor
@echo.
@echo where:
@echo     flavor : Debug or Release
@echo.

:End
