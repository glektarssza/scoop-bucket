if(!$env:SCOOP_HOME) { $env:SCOOP_HOME = Resolve-Path (scoop prefix scoop) }
$formatjson = "$PSScriptRoot/../scripts/formatjson.ps1"
$path = "$PSScriptRoot/../bucket" # checks the parent dir
& $formatjson -Dir $path @Args
