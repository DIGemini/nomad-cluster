job "http-echo" {
  # ...

  task "http-echo" {
    driver = "docker"

    config {
      image = "hashicorp/http-echo:${version}"

      args = [
        "-text", "'hello world'",
        "-listen", ":8080",
      ]

      port_map {
        http = 8080
      }
    }
  }
}