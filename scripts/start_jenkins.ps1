# Start Jenkins LTS in Docker
# Exposes port 8080 for UI and 50000 for agents

Write-Host "Starting Jenkins Container..." -ForegroundColor Green

docker run -d `
  -p 8080:8080 `
  -p 50000:50000 `
  --name jenkins-local `
  --restart on-failure `
  jenkins/jenkins:lts

Write-Host "Jenkins is starting up. It may take a minute."
Write-Host "To follow logs and get the initial admin password, run:"
Write-Host "docker logs -f jenkins-local" -ForegroundColor Yellow
