# -----------------------------------------------------------
# AWS Secrets Manager
# -----------------------------------------------------------
resource "aws_secretsmanager_secret" "app_secrets" {
  name        = "${var.app_name}-db-credentials-${random_id.suffix.hex}"
  description = "Application Database Credentials"
}

resource "aws_secretsmanager_secret_version" "app_secrets_val" {
  secret_id     = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    username = "admin"
    password = "change_me_in_production"
  })
}

resource "random_id" "suffix" {
  byte_length = 4
}

# -----------------------------------------------------------
# Monitoring & Logging
# -----------------------------------------------------------

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = 7
}

# Datadog Integration (Simulated/Placeholder)
# Note: In a real scenario, you would use the Datadog Provider or inject the API Key
variable "datadog_api_key" {
  description = "Datadog API Key"
  default     = "mock_dd_api_key_12345"
  sensitive   = true
}
