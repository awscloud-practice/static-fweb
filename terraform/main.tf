provider "local" {
  // The local provider executes scripts and copies files on your local machine.
}

resource "local_file" "setup_script" {
  content  = file("${path.module}/setup-iis.ps1")
  filename = "${path.module}/setup-iis.ps1"
}

resource "null_resource" "iis_setup" {
  provisioner "local-exec" {
    command = "powershell -ExecutionPolicy Bypass -File ${local_file.setup_script.filename}"
  }
  depends_on = [local_file.setup_script]
}

output "iis_website_url" {
  value = "http://localhost:8090"
}
