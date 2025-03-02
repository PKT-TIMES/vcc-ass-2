provider "google" {
  project     = "m23aid055-pritish-vcc-ass2"  # Replace with your GCP project ID
  credentials = file("/Users/pktsangs/Downloads/m23aid055-pritish-vcc-ass2-7be51308fb86.json")
  region      = "us-central1"  # Replace with your desired region
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "m23aid055-my-vpc-network"
  auto_create_subnetworks = true
}

# Create a firewall rule to allow HTTP traffic
resource "google_compute_firewall" "allow_http" {
  name    = "m23aid055-allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]  # Allow traffic from anywhere
}

# Create a firewall rule to allow SSH traffic
resource "google_compute_firewall" "allow_ssh" {
  name    = "m23aid055-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]  # Allow SSH from anywhere
}

# Create an instance template
resource "google_compute_instance_template" "instance_template" {
  name         = "m23aid055-my-instance-template"
  machine_type = "e2-medium"

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      # Assign a public IP
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx git stress-ng

    # Deploy a simple web application
    mkdir -p /var/www/html
    echo "<!DOCTYPE html>
    <html>
    <head>
        <title>My Application</title>
    </head>
    <body>
        <h1>Welcome to My Application!</h1>
        <p>This is a simple web application deployed on Nginx.</p>
    </body>
    </html>" > /var/www/html/index.html

    # Configure Nginx to serve the application
    rm /etc/nginx/sites-enabled/default
    echo "server {
        listen 80;
        server_name _;
        root /var/www/html;
        index index.html;
        location / {
            try_files \$uri \$uri/ =404;
        }
    }" > /etc/nginx/sites-available/myapp
    ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/

    # Restart Nginx to apply the changes
    systemctl restart nginx

    # Simulate CPU load using stress-ng
    stress-ng --cpu 2 --timeout 600 &  # Run stress-ng on 2 CPUs for 10 minutes
  EOF
}

# Create a managed instance group with auto-scaling
resource "google_compute_instance_group_manager" "mig" {
  name               = "m23aid055-my-mig"
  base_instance_name = "m23aid055-my-instance"
  zone               = "us-central1-a"  # Replace with your desired zone

  version {
    instance_template = google_compute_instance_template.instance_template.id
  }

  target_size = 1  # Initial number of instances

  auto_healing_policies {
    health_check      = google_compute_health_check.health_check.id
    initial_delay_sec = 300
  }
}

# Configure auto-scaling based on CPU utilization
resource "google_compute_autoscaler" "autoscaler" {
  name   = "m23aid055-my-autoscaler"
  zone   = "us-central1-a"  # Replace with your desired zone
  target = google_compute_instance_group_manager.mig.id

  autoscaling_policy {
    max_replicas    = 8
    min_replicas    = 1
    cooldown_period = 50

    cpu_utilization {
      target = 0.5  # Scale when CPU utilization is above 50%
    }
  }
}

# Create a health check for the instance group
resource "google_compute_health_check" "health_check" {
  name = "m23aid055-my-health-check"

  http_health_check {
    port = 80
  }
}

# Output the public IP of the instance group
output "public_ip" {
  value = google_compute_instance_group_manager.mig.instance_group
}
