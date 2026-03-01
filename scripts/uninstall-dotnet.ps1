info "Checking if SDK/runtime version $version has been installed..."
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/$version.lock")) {
    error "SDK/runtime version $version has not been installed!"
    return $false
}
info 'Reading lock file and deleting shared dotnet data...'
Get-Content -Path "$env:LOCALAPPDATA/dotnet-sdks/$version.lock" | Get-Item | Remove-Item -Recurse -Force
info 'Deleting lock file...'
Remove-Item "$env:LOCALAPPDATA/dotnet-sdks/$version.lock"
info 'Deleting symbolic links...'
warn "This might fail if you can't delete symbolic links!"
(Get-Item -Path "$dir/host/").Delete()
(Get-Item -Path "$dir/sdk/").Delete()
(Get-Item -Path "$dir/packs/").Delete()
(Get-Item -Path "$dir/sdk-manifests/").Delete()
(Get-Item -Path "$dir/shared/").Delete()
(Get-Item -Path "$dir/templates/").Delete()
info 'Done!'
return $true
