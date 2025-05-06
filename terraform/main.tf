terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
}

resource "docker_image" "node_hello" {
  name = "zeinsss/node-hello:latest"
}

resource "docker_container" "node_hello" {
  name  = "node-hello-container"
  image = docker_image.node_hello.name

  ports {
    internal = 3000
    external = 3000
  }
}
