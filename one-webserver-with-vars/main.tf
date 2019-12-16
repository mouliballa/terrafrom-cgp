provider "google" {
project = "gce-challange"
  region  = "us-centra11"
  zone    = "us-central1-a"
}


resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance-mine"
  machine_type = "f1-micro"
  tags = [ "http-server" , "yes" ]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
metadata_startup_script = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allw-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["${var.server_port}"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}


