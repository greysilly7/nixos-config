{...}: {
  lancache = {
    dns = {
      enable = true;
      forwarders = ["1.1.1.1" "8.8.8.8"];
      cache = "greysilly7.xyz";
    };
    cache = {
      enable = true;
      resolvers = ["1.1.1.1" "8.8.8.8"];
    };
  };
}
