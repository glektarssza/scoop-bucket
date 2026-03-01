info "Checking if SDK/runtime version $version has already been installed..."
if (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/$version.lock") {
    error "SDK/runtime version $version has already been installed!"
    return $false
}
info 'Checking if shared dotnet data location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/")) {
    info 'Shared dotnet data location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/"
}
info 'Checking if shared dotnet host fxr location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/host/fxr/")) {
    info 'Shared dotnet host fxr location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/host/fxr/"
}
info 'Checking if shared dotnet SDK location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/sdk/")) {
    info 'Shared dotnet SDK location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/sdk/"
}
info 'Checking if shared dotnet packs location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/packs/")) {
    info 'Shared dotnet packs location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/packs/"
}
info 'Checking if shared dotnet SDK manifests location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/sdk-manifests/")) {
    info 'Shared dotnet SDK manifests location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/sdk-manifests/"
}
info 'Checking if shared dotnet shared data manifests location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/shared/")) {
    info 'Shared dotnet shared data manifests location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/shared/"
}
info 'Checking if shared dotnet templates data manifests location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/templates/")) {
    info 'Shared dotnet templates data manifests location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/templates/"
}
$filesOperatedOn = [System.Collections.Generic.List[string]]::new()
info 'Relocating dotnet host fxr to shared location...'
Get-ChildItem -Path "$dir/host/fxr/" | Move-Item -PassThru -Destination "$env:LOCALAPPDATA/dotnet-sdks/host/fxr/" | ForEach-Object { $filesOperatedOn.Add($_.FullName) }
Remove-Item -Recurse -Path "$dir/host/"
info 'Relocating dotnet SDK to shared location...'
Get-ChildItem -Path "$dir/sdk/" | Move-Item -PassThru -Destination "$env:LOCALAPPDATA/dotnet-sdks/sdk/" | ForEach-Object { $filesOperatedOn.Add($_.FullName) }
Remove-Item -Recurse -Path "$dir/sdk/"
info 'Relocating dotnet packs to shared location...'
Get-ChildItem -Path "$dir/packs/" | ForEach-Object { Move-Item -Path $_ -Destination "$env:LOCALAPPDATA/dotnet-sdks/packs/$($_.Directory.Parent.BaseName)" | ForEach-Object { $filesOperatedOn.Add($_.FullName) } }
Remove-Item -Recurse -Path "$dir/packs/"
info 'Relocating dotnet SDK manifests to shared location...'
Get-ChildItem -Path "$dir/sdk-manifests/" | Move-Item -PassThru -Destination "$env:LOCALAPPDATA/dotnet-sdks/sdk-manifests/" | ForEach-Object { $filesOperatedOn.Add($_.FullName) }
Remove-Item -Recurse -Path "$dir/sdk-manifests/"
info 'Relocating dotnet shared data manifests to shared location...'
Get-ChildItem -Path "$dir/shared/" | ForEach-Object { Move-Item -Path $_ -Destination "$env:LOCALAPPDATA/dotnet-sdks/shared/$($_.Directory.Parent.BaseName)" | ForEach-Object { $filesOperatedOn.Add($_.FullName) } }
Remove-Item -Recurse -Path "$dir/shared/"
info 'Relocating dotnet templates data manifests to shared location...'
Get-ChildItem -Path "$dir/templates/" | Move-Item -PassThru -Destination "$env:LOCALAPPDATA/dotnet-sdks/templates/" | ForEach-Object { $filesOperatedOn.Add($_.FullName) }
Remove-Item -Recurse -Path "$dir/templates/"
info 'Linking shared SDK locations to scoop app path locations...'
warn "This might fail if you can't create symbolic links!"
New-Item -Type SymbolicLink -Path "$dir/host/" -Target "$env:LOCALAPPDATA/dotnet-sdk/host/"
New-Item -Type SymbolicLink -Path "$dir/sdk/" -Target "$env:LOCALAPPDATA/dotnet-sdk/sdk/"
New-Item -Type SymbolicLink -Path "$dir/packs/" -Target "$env:LOCALAPPDATA/dotnet-sdk/packs/"
New-Item -Type SymbolicLink -Path "$dir/sdk-manifests/" -Target "$env:LOCALAPPDATA/dotnet-sdk/sdk-manifests/"
New-Item -Type SymbolicLink -Path "$dir/shared/" -Target "$env:LOCALAPPDATA/dotnet-sdk/shared/"
New-Item -Type SymbolicLink -Path "$dir/templates/" -Target "$env:LOCALAPPDATA/dotnet-sdk/templates/"
info 'Writing lock file...'
$filesOperatedOn | Out-File -Encoding utf8 -Path "$env:LOCALAPPDATA/dotnet-sdks/$version.lock"
info 'Done!'
return $true
