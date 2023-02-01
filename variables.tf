variable "cluster_name" {
  type        =  string
  description = "The name of the ECS Cluster"
}

variable "name" {
  description = "(required, forces new resource) Name of service"
}


variable "tags" {
  description = "Tags applied to all resources."
  default     = {}
  type        = map(string)
}

variable "cloudwatch_metric_alarm_tags" {
  description = "Tags for the all cloudwatch metric alarms."
  default     = {}
  type        = map(string)
}

#--------------------------------------------------
# High CPU Alarm
#--------------------------------------------------

variable "create_high_cpu_alarm" {
    type        = bool
    default     = false
    description = "(optional) Creates high CPU alarm resources"
}

variable "high_cpu_sns_topic_name" {
  type        = string
  description = "(optional) SNS topic where alarms will be send"
}

variable "alarm_high_cpu_evaluation_periods" {
  type        = string
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "1"
}

variable "alarm_high_cpu_period" {
  type        = string
  description = "The period in seconds over which the specified statistic is applied"
  default     = "60"
}

variable "alarm_high_cpu_statistic" {
  type        = string
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

variable "alarm_high_cpu_threshold" {
  type        = string
  description = "The value against which the specified statistic is compared."
  default     = "60"
}

#--------------------------------------------------
# Low CPU Alarm
#--------------------------------------------------

variable "create_low_cpu_alarm" {
    type        = bool
    default     = false
    description = "(optional) Creates low CPU alarm resources"
}

variable "low_cpu_sns_topic_name" {
  type        = string
  description = "(optional) SNS topic where alarms will be send"
}

variable "alarm_low_cpu_evaluation_periods" {
  type        = string
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "1"
}

variable "alarm_low_cpu_period" {
  type        = string
  description = "The period in seconds over which the specified statistic is applied"
  default     = "60"
}

variable "alarm_low_cpu_statistic" {
  type        = string
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Average"
}

variable "alarm_low_cpu_threshold" {
  type        = string
  description = "The value against which the specified statistic is compared."
  default     = "10"
}


#--------------------------------------------------
# Log Pattern Alarm Options
#--------------------------------------------------

variable "create_log_pattern_alarm" {
    type        = bool
    default     = false
    description = "(optional) Creates logs pattern alarm resources"
}

variable "log_pattern_sns_topic_name" {
  type        = string
  description = "(optional) SNS topic where alarms will be send"
}

variable "log_group_name" {
  type        = string
  description = "(optional) CloudWatch Log Group name"
}

variable "log_pattern" {
  type        = string
  description = "(optional) Pattern to match in log group"
}

variable "log_pattern_alias" {
  type        = string
  description = "(optional) Alias for your pattern that can be attached to filter name and alarm name"
}

variable "log_pattern_evaluation_periods" {
  description = "(optional) The number of periods over which data is compared to the specified threshold."
  type        = string
  default     = "1"
}

variable "log_pattern_threshold" {
  description = "(optional) The value against which the specified statistic is compared"
  type        = number
  default     = 1
}


variable "log_pattern_period" {
  description = "(optional) The period in seconds over which the specified statistic is applied"
  type        = string
  default     = "60"
}

variable "log_pattern_statistic" {
  type        = string
  default     = "Sum"
  description = "(optional) The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
}
