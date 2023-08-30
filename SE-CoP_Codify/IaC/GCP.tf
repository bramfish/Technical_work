provider "google" {
    project = "your-project-id"
    region  = "us-central1"
    zone    = "us-central1-a"
}

resource "google_compute_network" "vpc_network" {
    name                    = "my-vpc-network"
    auto_create_subnetworks = false
    labels = {
        "SE-CoP" = "true"
    }
}

resource "google_compute_subnetwork" "subnet_1" {
    name          = "subnet-1"
    ip_cidr_range = "10.0.1.0/24"
    network       = google_compute_network.vpc_network.self_link
    region        = "us-central1"
    labels = {
        "SE-CoP" = "true"
    }
}

resource "google_compute_subnetwork" "subnet_2" {
    name          = "subnet-2"
    ip_cidr_range = "10.0.2.0/24"
    network       = google_compute_network.vpc_network.self_link
    region        = "us-central1"
    labels = {
        "SE-CoP" = "true"
    }
}

resource "google_compute_subnetwork" "subnet_3" {
    name          = "subnet-3"
    ip_cidr_range = "10.0.3.0/24"
    network       = google_compute_network.vpc_network.self_link
    region        = "us-central1"
    labels = {
        "SE-CoP" = "true"
    }
}

resource "google_compute_instance" "windows_vm" {
    name         = "windows-vm"
    machine_type = "n1-standard-1"
    zone         = "us-central1-a"
    labels = {
        "SE-CoP" = "true"
    }

    boot_disk {
        initialize_params {
            image = "windows-server-2019-dc-core-v20220118"
        }
    }

    network_interface {
        subnetwork = google_compute_subnetwork.subnet_1.self_link
    }
}

resource "google_compute_backend_service" "backend_service" {
    name        = "backend-service"
    protocol    = "HTTP"
    timeout_sec = 10
    labels = {
        "SE-CoP" = "true"
    }

    backend {
        group = google_compute_instance_group.instance_group.self_link
    }

    health_checks = [google_compute_http_health_check.http_health_check.self_link]

    load_balancing_scheme = "INTERNAL"
    network               = google_compute_network.vpc_network.self_link
    subnetwork            = google_compute_subnetwork.subnet_2.self_link
}

resource "google_compute_http_health_check" "http_health_check" {
    name               = "http-health-check"
    port               = 80
    request_path       = "/"
    check_interval_sec = 10
    timeout_sec        = 5
    labels = {
        "SE-CoP" = "true"
    }
}

resource "google_compute_firewall" "firewall_1" {
    name    = "firewall-1"
    network = google_compute_network.vpc_network.self_link
    labels = {
        "SE-CoP" = "true"
    }

    allow {
        protocol = "tcp"
        ports    = ["5432"]
    }

    source_ranges = [google_compute_subnetwork.subnet_1.ip_cidr_range]
    target_tags   = ["postgres"]
}

resource "google_compute_firewall" "firewall_2" {
    name    = "firewall-2"
    network = google_compute_network.vpc_network.self_link
    labels = {
        "SE-CoP" = "true"
    }

    allow {
        protocol = "tcp"
        ports    = ["80"]
    }

    source_ranges = [google_compute_subnetwork.subnet_2.ip_cidr_range]
    target_tags   = ["http-server"]
}

resource "google_dns_managed_zone" "dns_zone" {
    name        = "my-dns-zone"
    dns_name    = "example.com."
    description = "My DNS zone"
    labels = {
        "SE-CoP" = "true"
    }
}

resource "google_dns_record_set" "dns_record" {
    name    = "www"
    type    = "A"
    ttl     = 300
    rrdatas = ["10.0.2.2"]
    managed_zone = google_dns_managed_zone.dns_zone.name
    labels = {
        "SE-CoP" = "true"
    }
}

resource "google_sql_database_instance" "postgres_instance" {
    name             = "postgres-instance"
    database_version = "POSTGRES_13"
    region           = "us-central1"
    labels = {
        "SE-CoP" = "true"
    }

    settings {
        tier = "db-f1-micro"
    }

    depends_on = [google_compute_firewall.firewall_1]

    deletion_protection = false
}

resource "google_sql_database" "postgres_db" {
    name     = "postgres-db"
    instance = google_sql_database_instance.postgres_instance.name
    charset  = "UTF8"
    collation = "en_US.UTF8"
    labels = {
        "SE-CoP" = "true"
    }
}

resource "google_compute_instance_group" "instance_group" {
    name        = "instance-group"
    description = "Instance group"
    zone        = "us-central1-a"
    labels = {
        "SE-CoP" = "true"
    }

    named_port {
        name = "http"
        port = 80
    }

    network_interface {
        subnetwork = google_compute_subnetwork.subnet_2.self_link
    }

    instance_template = google_compute_instance_template.instance_template.self_link
}

resource "google_compute_instance_template" "instance_template" {
    name = "instance-template"

    disk {
        source_image = "debian-cloud/debian-10"
    }

    network_interface {
        subnetwork = google_compute_subnetwork.subnet_2.self_link
    }

    metadata_startup_script = "echo 'Hello, World!'"
    labels = {
        "SE-CoP" = "true"
    }
}
provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "vpc_network" {
    cidr_block = "10.0.0.0/16"
    tags = {
        "SE-CoP" = "true"
    }
}

resource "aws_subnet" "subnet_1" {
    cidr_block = "10.0.1.0/24"
    vpc_id     = aws_vpc.vpc_network.id
    tags = {
        "SE-CoP" = "true"
    }
}

resource "aws_subnet" "subnet_2" {
    cidr_block = "10.0.2.0/24"
    vpc_id     = aws_vpc.vpc_network.id
    tags = {
        "SE-CoP" = "true"
    }
}

resource "aws_subnet" "subnet_3" {
    cidr_block = "10.0.3.0/24"
    vpc_id     = aws_vpc.vpc_network.id
    tags = {
        "SE-CoP" = "true"
    }
}

resource "aws_instance" "windows_vm" {
    ami           = "ami-0c94855ba95c71c99"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.subnet_1.id
    tags = {
        "SE-CoP" = "true"
    }
}

resource "aws_lb" "load_balancer" {
    name               = "my-load-balancer"
    internal           = true
    load_balancer_type = "application"
    subnets            = [aws_subnet.subnet_2.id]
    security_groups    = [aws_security_group.load_balancer.id]
    tags = {
        "SE-CoP" = "true"
    }
}

resource "aws_security_group" "load_balancer" {
    name_prefix = "load-balancer"
    vpc_id      = aws_vpc.vpc_network.id
    tags = {
        "SE-CoP" = "true"
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [aws_subnet.subnet_2.cidr_block]
    }
}

resource "aws_security_group" "postgres" {
    name_prefix = "postgres"
    vpc_id      = aws_vpc.vpc_network.id
    tags = {
        "SE-CoP" = "true"
    }

    ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = [aws_subnet.subnet_1.cidr_block]
    }
}

resource "aws_db_instance" "postgres_instance" {
    allocated_storage    = 20
    engine               = "postgres"
    engine_version       = "13.4"
    instance_class       = "db.t2.micro"
    name                 = "postgres-instance"
    username             = "postgres"
    password             = "postgres"
    parameter_group_name = "default.postgres13"
    skip_final_snapshot  = true
    vpc_security_group_ids = [aws_security_group.postgres.id]
    subnet_group_name      = "postgres-subnet-group"
    tags = {
        "SE-CoP" = "true"
    }
}

resource "aws_security_group_rule" "http_server" {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.subnet_2.cidr_block]
    security_group_id = aws_security_group.load_balancer.id
}

resource "aws_security_group_rule" "postgres_db" {
    type        = "ingress"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.subnet_1.cidr_block]
    security_group_id = aws_security_group.postgres.id
}

resource "aws_security_group_rule" "ssh_access" {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.postgres.id
}

resource "aws_security_group_rule" "all_outbound" {
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.postgres.id
}
