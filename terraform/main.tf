terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}



variable "newrelic_license_key" {
  description = "Your New Relic license key for log ingestion"
  type        = string
}


resource "docker_image" "node_hello" {
  name = "zeinsss/node-hello:latest"
}


resource "docker_image" "fluentd" {
  name         = "newrelic/newrelic-fluentd-docker:latest"
  keep_locally = false
}

resource "docker_container" "fluentd" {
  name  = "newrelic-fluentd"
  image = docker_image.fluentd.name

  # Pass your license key to the Fluentd agent
  env = [
    "API_KEY=${var.newrelic_license_key}",
    "BASE_URI=https://log-api.newrelic.com/log/v1"
  ]

  ports {
    internal = 24224
    external = 24224
  }

  restart = "always"
}


resource "docker_container" "node_hello" {
  name  = "node-hello-container"
  image = docker_image.node_hello.name

  ports {
    internal = 3000
    external = 3000
  }

  # Send all stdout/stderr into Fluentd
  log_driver = "fluentd"
  log_opts = {
    "fluentd-address" = "127.0.0.1:24224"
    "tag"             = "node-hello-container"
  }

  # ensure the log shipper is up before the app
  depends_on = [docker_container.fluentd]
}