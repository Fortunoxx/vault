$path = "kv/path/to/secret"
$outFile = ".env"
$user = "testuser"
$env:VAULT_ADDR = "http://localhost:8200"
# $password = "28f231ff-d38c-4d49-ac10-24f06d258aae"

# vault login -method=userpass username=$user #password=$password
$s = vault kv get -format=json $path| ConvertFrom-Json
$kv = $s.data.data   # KV v2

$lines = $kv.PSObject.Properties | ForEach-Object {
  "$($_.Name)=$($_.Value)"
}

$lines | Set-Content -Path $outFile -Encoding ascii