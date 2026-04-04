$path = "kv/path/to/secret"
$outFile = ".env"
$vault_addr = "https://localhost:443"

$s = vault kv get -format=json -address $vault_addr -tls-skip-verify $path| ConvertFrom-Json
$kv = $s.data.data   # KV v2

$lines = $kv.PSObject.Properties | ForEach-Object {
  "$($_.Name)=$($_.Value)"
}

$lines | Set-Content -Path $outFile -Encoding ascii