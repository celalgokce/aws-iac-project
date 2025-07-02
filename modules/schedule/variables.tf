variable "instance_id" {
  description = "EC2 instance ID to schedule"
  type        = string
}

variable "enable_schedule" {
  description = "Enable EC2 scheduling"
  type        = bool
  default     = false
}

variable "start_schedule" {
  description = "Cron expression for starting EC2 at 00:00 UTC (midnight)"
  type        = string
  default     = "cron(0 0 * * ? *)"  # Her gün 00:00'da başlat
}

variable "stop_schedule" {
  description = "Cron expression for stopping EC2 at 18:00 UTC (6 PM)"
  type        = string
  default     = "cron(0 18 * * ? *)"  # Her gün 18:00'da kapat
}