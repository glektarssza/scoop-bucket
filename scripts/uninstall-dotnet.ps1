info "Checking if SDK/runtime version $version has been installed..."
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/$version.lock")) {
    error "SDK/runtime version $version has not been installed!"
    return $false
}
info 'Reading lock file and deleting shared dotnet data...'
Get-Content -Path "$env:LOCALAPPDATA/dotnet-sdks/$version.lock" | ForEach-Object { ($_ -split '=')[1] } | Get-Item | Remove-Item -Recurse -Force
info 'Reading lock file and deleting symbolic links...'
warn "This might fail if you can't delete symbolic links!"
(Get-Content -Path "$env:LOCALAPPDATA/dotnet-sdks/$version.lock" | ForEach-Object { ($_ -split '=')[0] } | Get-Item).Delete()
info 'Deleting lock file...'
Remove-Item "$env:LOCALAPPDATA/dotnet-sdks/$version.lock"
info 'Done!'
return $true
