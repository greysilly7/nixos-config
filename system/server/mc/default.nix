{...}: {
  imports = [./iremia];

  services.minecraft-servers = {
    enable = true;
    eula = true;
  };
}
