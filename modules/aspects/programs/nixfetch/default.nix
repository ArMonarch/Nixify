{inputs', ...}: {
  environment.systemPackages = [
    inputs'.nixfetch.packages.default
  ];

  environment.variables = {
    NIXFETCH_IMAGE = "/home/frenzfries/Project/Nixify/modules/aspects/programs/nixfetch/alice_glasses.png";
  };
}
