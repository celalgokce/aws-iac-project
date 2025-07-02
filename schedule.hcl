include {
  path = find_in_parent_folders()
}

dependency "ec2" {
  config_path = "."
  mock_outputs = {
    instance_id = "i-12345"
  }
}

terraform {
  source = "./modules/schedule"
}

inputs = {
  instance_id     = dependency.ec2.outputs.instance_id
  enable_schedule = false  # İlk kurulumda false, sonra true yapabilirsiniz
  start_schedule  = "cron(0 0 * * ? *)"   # Her gün 00:00'da başlat (UTC)
  stop_schedule   = "cron(0 18 * * ? *)"  # Her gün 18:00'da kapat (UTC)
}