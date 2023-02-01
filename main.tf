data "aws_ecs_cluster" "this" {
  cluster_name = var.cluster_name
}

data "aws_sns_topic" "high_cpu" {
  name = var.high_cpu_sns_topic_name
}

data "aws_sns_topic" "low_cpu" {
  name = var.low_cpu_sns_topic_name
}

data "aws_sns_topic" "log_pattern" {
  name = var.log_pattern_sns_topic_name
}

data "aws_cloudwatch_log_group" "this" {
  name = var.log_group_name
}

#------------------------------------------------------------------------------
# CloudWatch High CPU Alarm
#------------------------------------------------------------------------------

# CloudWatch alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count               = var.create_high_cpu_alarm ? 1 : 0

  alarm_name          = "${var.name}-cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_high_cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.alarm_high_cpu_period
  statistic           = var.alarm_high_cpu_statistic
  threshold           = var.alarm_high_cpu_threshold

  dimensions = {
    ClusterName = data.aws_ecs_cluster.this.name
    ServiceName = var.name
  }

  alarm_actions = [var.aws_sns_topic.high_cpu.arn]

  tags          = merge(var.tags, var.cloudwatch_metric_alarm_tags)
}

#------------------------------------------------------------------------------
# CloudWatch Low CPU Alarm
#------------------------------------------------------------------------------

# CloudWatch alarm
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  count               = var.create_low_cpu_alarm ? 1 : 0

  alarm_name          = "${var.name}-cpu-utilization-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_low_cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.alarm_low_cpu_period
  statistic           = var.alarm_low_cpu_statistic
  threshold           = var.alarm_low_cpu_threshold

  dimensions = {
    ClusterName = data.aws_ecs_cluster.this.cluster_name
    ServiceName = var.name
  }

  alarm_actions = [data.aws_sns_topic.low_cpu.arn]

  tags          = merge(var.tags, var.cloudwatch_metric_alarm_tags)
}

#------------------------------------------------------------------------------
# CloudWatch Log Pattern Alarm
#------------------------------------------------------------------------------

# CloudWatch log metric filter
resource "aws_cloudwatch_log_metric_filter" "log_pattern" {
  count = var.create_log_pattern_alarm ? 1 : 0

  name           = "${var.name}-${var.log_pattern_alias}-log"
  pattern        = var.log_pattern
  log_group_name = data.aws_cloudwatch_log_group.this.name

  metric_transformation {
    name          = "${var.name}-${var.log_pattern_alias}-log"
    namespace     = "${var.name}"
    value         = "1"
    unit          = "Count"
  }
}

# CloudWatch alarm
resource "aws_cloudwatch_metric_alarm" "log_pattern" {
  count = var.create_log_pattern_alarm ? 1 : 0

  alarm_name        = "${var.name}-${var.log_pattern_alias}-log"
  alarm_description = "Counts ${var.log_pattern_alias} messages in logs"
  actions_enabled   = true

  alarm_actions = [data.aws_sns_topic.log_pattern.arn]

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.log_pattern_evaluation_periods
  threshold           = var.log_pattern_threshold

  datapoints_to_alarm = 1
  treat_missing_data  = "missing"

  metric_name        = "${var.name}-${var.log_pattern_alias}-log"
  namespace          = "${var.name}"
  period             = var.log_pattern_period
  statistic          = var.log_pattern_statistic

  tags = merge(var.tags, var.cloudwatch_metric_alarm_tags)
}
