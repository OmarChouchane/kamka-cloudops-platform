resource "aws_ssm_parameter" "postgres_password" {
  name        = "/kamka/POSTGRES_PASSWORD"
  description = "PostgreSQL password for kamka services"
  type        = "SecureString"
  value       = var.db_password

  tags = {
    Name    = "kamka-postgres-password"
    Project = var.project_name
  }
}

resource "aws_ssm_parameter" "slack_webhook_url" {
  name        = "/kamka/SLACK_WEBHOOK_URL"
  description = "Slack incoming webhook URL for alerts and notifications"
  type        = "SecureString"
  value       = var.slack_webhook_url

  tags = {
    Name    = "kamka-slack-webhook"
    Project = var.project_name
  }
}

resource "aws_ssm_parameter" "grafana_password" {
  name        = "/kamka/GRAFANA_PASSWORD"
  description = "Grafana admin password"
  type        = "SecureString"
  value       = var.grafana_password

  tags = {
    Name    = "kamka-grafana-password"
    Project = var.project_name
  }
}
