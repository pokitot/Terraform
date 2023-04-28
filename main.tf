# Configure the required providers
terraform {
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.50.2" # Version 2.50.2 or later
    }
  }
}

# Configure the New Relic provider with your account ID and API key
provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
}

# Create a New Relic alert policy for monitoring memory usage
resource "newrelic_alert_policy" "memory_usage" {
  name = "Memory_usage"
}

# Create a New Relic NRQL alert condition for memory usage warning
resource "newrelic_nrql_alert_condition" "memory_warning" {
  policy_id = newrelic_alert_policy.memory_usage.id
  name      = "Memory Usage Warning"
  type      = "static"

  # Define the NRQL query for monitoring average memory used percentage
  nrql {
    query             = "SELECT average(memoryUsedPercent) as 'Used Memory' FROM SystemSample WHERE hostname IS NOT NULL"
    evaluation_offset = "1"
  }

  value_function       = "single_value"
  violation_time_limit = "TWENTY_FOUR_HOURS"

  # Define the critical threshold for the alert condition
  critical {
    operator              = "above"
    threshold             = "90"
    threshold_duration    = "300"
    threshold_occurrences = "ALL"
  }

  # Define the warning threshold for the alert condition
  warning {
    operator              = "above"
    threshold             = "80"
    threshold_duration    = "300"
    threshold_occurrences = "ALL"
  }
}
resource "newrelic_alert_policy" "password_generator_policy" {
  name = "PassWord Generator Policy"
}

resource "newrelic_nrql_alert_condition" "password_generator_warning_condition" {
  policy_id       = newrelic_alert_policy.password_generator_policy.id
  name            = "PassWord Generator - Warning"
  value_function  = "single_value"

  nrql {
    query           = "SELECT average(duration) FROM PageView WHERE appName = 'PassWord Generator'"
    evaluation_offset = "2"
  }

  critical {
    operator              = "above"
    threshold             = "0.3"
    threshold_duration    = 600
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "password_generator_critical_condition" {
  policy_id       = newrelic_alert_policy.password_generator_policy.id
  name            = "PassWord Generator - Critical"
  value_function  = "single_value"

  nrql {
    query           = "SELECT average(duration) FROM PageView WHERE appName = 'PassWord Generator'"
    evaluation_offset = "2"
  }

  critical {
    operator              = "above"
    threshold             = "0.3"
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}
