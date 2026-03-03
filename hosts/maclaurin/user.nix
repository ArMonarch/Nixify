{inputs', ...}: {
  users.users.frenzfries = {
    isNormalUser = true;
    description = "frenzfries";
    extraGroups = ["networkmanager" "wheel"];
    packages = [
      inputs'.nixvim.packages.nixvim
    ];
  };
}
