# Configure the required providers
terraform {
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
      # Version 2.50.2 or later
      version = "~> 2.50.2"
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
# Define a New Relic alert policy named "PassWord Generator Policy"
resource "newrelic_alert_policy" "password_generator_policy" {
  name = "PassWord Generator Policy"
}

# Define a NRQL alert condition for the above policy
# This condition is for warning situations, where average page load duration is above 0.3 for more than 600 seconds
resource "newrelic_nrql_alert_condition" "password_generator_warning_condition" {
  # Reference the ID of the above defined alert policy
  policy_id = newrelic_alert_policy.password_generator_policy.id
  name      = "PassWord Generator - Warning"
  # This alert is based on a single value, not a summary of all data points
  value_function = "single_value"

  # Define the NRQL query to be used for this alert condition
  nrql {
    # Query average duration from PageView events for 'PassWord Generator' application
    query = "SELECT average(duration) FROM PageView WHERE appName = 'PassWord Generator'"
    # Set the evaluation offset to 2 minutes
    evaluation_offset = "2"
  }

  # Define the critical situation for this condition
  critical {
    # The critical situation is when the average duration is above 0.3
    operator  = "above"
    threshold = "0.3"
    # The duration for which the threshold has to be crossed for the alert to be triggered is 600 seconds
    threshold_duration = 600
    # Alert will be triggered only if all data points in the duration window violate the threshold
    threshold_occurrences = "ALL"
  }
}

# Define a NRQL alert condition for the above policy
# This condition is for critical situations, where average page load duration is above 0.3 for more than 300 seconds
resource "newrelic_nrql_alert_condition" "password_generator_critical_condition" {
  # Reference the ID of the above defined alert policy
  policy_id = newrelic_alert_policy.password_generator_policy.id
  name      = "PassWord Generator - Critical"
  # This alert is based on a single value, not a summary of all data points
  value_function = "single_value"

  # Define the NRQL query to be used for this alert condition
  nrql {
    # Query average duration from PageView events for 'PassWord Generator' application
    query = "SELECT average(duration) FROM PageView WHERE appName = 'PassWord Generator'"
    # Set the evaluation offset to 2 minutes
    evaluation_offset = "2"
  }

  # Define the critical situation for this condition
  critical {
    # The critical situation is when the average duration is above 0.3
    operator  = "above"
    threshold = "0.3"
    # The duration for which the threshold has to be crossed for the alert to be triggered is 300 seconds
    threshold_duration = 300
    # Alert will be triggered only if all data points in the duration window violate the threshold
    threshold_occurrences = "ALL"
  }
}
