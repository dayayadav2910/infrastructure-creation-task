output "webapp" {
  value       = "PORT=${var.PORT} "
  sensitive   = true
  description = "description"
  depends_on  = []
}
