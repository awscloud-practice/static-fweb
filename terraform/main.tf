provider "local" {}

resource "null_resource" "setup_iis" {
  provisioner "local-exec" {
    command = <<EOT
      powershell -command "
      \$siteName = 'DuplicateSite';
      \$sitePath = 'C:\\inetpub\\wwwroot\\DuplicateSite';
      \$bindingIP = '*';
      \$bindingPort = 80;

      # Ensure the folder exists
      if (-not (Test-Path \$sitePath)) {
        New-Item -Path \$sitePath -ItemType Directory;
      }

      # Check if the site exists
      \$site = Get-Website | Where-Object { \$_.Name -eq \$siteName };

      if (\$null -eq \$site) {
          # Create a new site if it doesn't exist
          New-Website -Name \$siteName -PhysicalPath \$sitePath -Port \$bindingPort;
      } else {
          # Update the existing site
          Set-ItemProperty 'IIS:\\Sites\\' + \$siteName -Name physicalPath -Value \$sitePath;
          Remove-WebBinding -Name \$siteName -IPAddress \$bindingIP -Port \$bindingPort;
          New-WebBinding -Name \$siteName -IPAddress \$bindingIP -Port \$bindingPort;
          Start-Website -Name \$siteName;
      }"
    EOT
  }
}

output "website_path" {
  value = "C:\\inetpub\\wwwroot\\DuplicateSite"
}
