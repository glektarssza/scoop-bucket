info "Checking if SDK/runtime version $version has already been installed..."
if (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/$version.lock") {
    error "SDK/runtime version $version has already been installed!"
    return $false
}
info 'Checking if shared dotnet data location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/")) {
    info 'Shared dotnet data location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/" | Out-Null
}
info 'Checking if shared dotnet host fxr location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/host/fxr/")) {
    info 'Shared dotnet host fxr location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/host/fxr/" | Out-Null
}
info 'Checking if shared dotnet SDK location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/sdk/")) {
    info 'Shared dotnet SDK location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/sdk/" | Out-Null
}
info 'Checking if shared dotnet packs location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/packs/")) {
    info 'Shared dotnet packs location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/packs/" | Out-Null
}
info 'Checking if shared dotnet SDK manifests location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/sdk-manifests/")) {
    info 'Shared dotnet SDK manifests location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/sdk-manifests/" | Out-Null
}
info 'Checking if shared dotnet shared data manifests location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/shared/")) {
    info 'Shared dotnet shared data manifests location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/shared/" | Out-Null
}
info 'Checking if shared dotnet templates data manifests location already exists...'
if (-not (Test-Path -Path "$env:LOCALAPPDATA/dotnet-sdks/templates/")) {
    info 'Shared dotnet templates data manifests location does not exist, creating...'
    New-Item -Type Directory -Force -Path "$env:LOCALAPPDATA/dotnet-sdks/templates/" | Out-Null
}
$filesOperatedOn = [System.Collections.Generic.Dictionary[string, string]]::new()
info 'Relocating dotnet host fxr to shared location...'
Get-ChildItem -Path "$dir/host/fxr/" | Move-Item -PassThru -Destination "$env:LOCALAPPDATA/dotnet-sdks/host/fxr/$version" | ForEach-Object { $filesOperatedOn.Add($_.FullName, "$env:LOCALAPPDATA/dotnet-sdks/host/fxr/$version/$($_.BaseName)") }
Remove-Item -Recurse -Path "$dir/host/"
info 'Relocating dotnet SDK to shared location...'
Get-ChildItem -Path "$dir/sdk/" | Move-Item -PassThru -Destination "$env:LOCALAPPDATA/dotnet-sdks/sdk/$version" | ForEach-Object { $filesOperatedOn.Add($_.FullName, "$env:LOCALAPPDATA/dotnet-sdks/sdks/$($_.BaseName)") }
Remove-Item -Recurse -Path "$dir/sdk/"
info 'Relocating dotnet packs to shared location...'
Get-ChildItem -Path "$dir/packs/" | ForEach-Object { $t = $_; Move-Item -Path $t -Destination "$env:LOCALAPPDATA/dotnet-sdks/packs/$($t.Directory.Parent.BaseName)/$version" | ForEach-Object { $filesOperatedOn.Add($_.FullName, "$env:LOCALAPPDATA/dotnet-sdks/packs/$($t.Directory.Parent.BaseName)/$($_.BaseName)") } }
Remove-Item -Recurse -Path "$dir/packs/"
info 'Relocating dotnet SDK manifests to shared location...'
Get-ChildItem -Path "$dir/sdk-manifests/" | Move-Item -PassThru -Destination "$env:LOCALAPPDATA/dotnet-sdks/sdk-manifests/$version" | ForEach-Object { $filesOperatedOn.Add($_.FullName, "$env:LOCALAPPDATA/dotnet-sdks/sdk-manifests/$($_.BaseName)") }
Remove-Item -Recurse -Path "$dir/sdk-manifests/"
info 'Relocating dotnet shared data manifests to shared location...'
Get-ChildItem -Path "$dir/shared/" | ForEach-Object { $t = $_; Move-Item -Path $t -Destination "$env:LOCALAPPDATA/dotnet-sdks/shared/$($t.Directory.Parent.BaseName)/$version" | ForEach-Object { $filesOperatedOn.Add($_.FullName, "$env:LOCALAPPDATA/dotnet-sdks/shared/$($t.Directory.Parent.BaseName)/$($_.BaseName)") } }
Remove-Item -Recurse -Path "$dir/shared/"
info 'Relocating dotnet templates data manifests to shared location...'
Get-ChildItem -Path "$dir/templates/" | Move-Item -PassThru -Destination "$env:LOCALAPPDATA/dotnet-sdks/templates/$version" | ForEach-Object { $filesOperatedOn.Add($_.FullName, "$env:LOCALAPPDATA/dotnet-sdks/templates/$version/$($_.BaseName)") }
Remove-Item -Recurse -Path "$dir/templates/"
info 'Linking shared SDK locations to scoop app path locations...'
warn "This might fail if you can't create symbolic links!"
New-Item -Type SymbolicLink -Path "$dir/host/" -Target "$env:LOCALAPPDATA/dotnet-sdk/host/" | Out-Null
New-Item -Type SymbolicLink -Path "$dir/sdk/" -Target "$env:LOCALAPPDATA/dotnet-sdk/sdk/" | Out-Null
New-Item -Type SymbolicLink -Path "$dir/packs/" -Target "$env:LOCALAPPDATA/dotnet-sdk/packs/" | Out-Null
New-Item -Type SymbolicLink -Path "$dir/sdk-manifests/" -Target "$env:LOCALAPPDATA/dotnet-sdk/sdk-manifests/" | Out-Null
New-Item -Type SymbolicLink -Path "$dir/shared/" -Target "$env:LOCALAPPDATA/dotnet-sdk/shared/" | Out-Null
New-Item -Type SymbolicLink -Path "$dir/templates/" -Target "$env:LOCALAPPDATA/dotnet-sdk/templates/" | Out-Null
info 'Writing lock file...'
$filesOperatedOn.GetEnumerator() | ForEach-Object { "$($_.Key)=$(_.Value)" | Out-File -Encoding utf8 -Path "$env:LOCALAPPDATA/dotnet-sdks/$version.lock" }
info 'Done!'
return $true
