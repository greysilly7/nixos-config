_: {
  flake.templates = {
    rust = {
      path = ../templates/rust;
      description = "Rust devShell with crane + memory-efficient linker";
    };
    dart-flutter = {
      path = ../templates/dart-flutter;
      description = "Flutter/Dart devShell -- no global pollution";
    };
    containerized-microservices = {
      path = ../templates/containerized-microservices;
      description = "Containerized microservice devShell with Podman";
    };
    default = {
      path = ../templates/rust;
      description = "Rust devShell (default)";
    };
  };
}
