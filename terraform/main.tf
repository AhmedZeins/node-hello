terraform {
 required_providers {
   docker = {
     source  = "kreuzwerker/docker"
     version = "3.0.2"
   }
 }
}
resource "docker_image" "node-hello" {
 name = "zeinsss/node-hello:latest"
}