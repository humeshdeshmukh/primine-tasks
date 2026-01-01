# Run Terraform using Docker (since it's not installed locally)
# Usage: ./tf_docker.ps1 <command> <access_key> <secret_key>
# Example: ./tf_docker.ps1 plan AKIA... SECRET...

param (
    [string]$Command = "plan",
    [string]$AccessKey,
    [string]$SecretKey,
    [string]$SessionTokenString = ""
)

$WorkDir = "/workspace"
$LocalDir = "$(Get-Location)\terraform"

Write-Host "Running Terraform '$Command' via Docker..." -ForegroundColor Cyan

# Prepare Environment Variables
$EnvVars = @(
    "-e", "AWS_ACCESS_KEY_ID=$AccessKey",
    "-e", "AWS_SECRET_ACCESS_KEY=$SecretKey",
    "-e", "AWS_DEFAULT_REGION=us-east-1"
)

if ($SessionTokenString -ne "") {
    $EnvVars += "-e", "AWS_SESSION_TOKEN=$SessionTokenString"
}

# Run Docker Command
docker run --rm -it `
    -v "${LocalDir}:${WorkDir}" `
    -w $WorkDir `
    $EnvVars `
    hashicorp/terraform:light `
    $Command
