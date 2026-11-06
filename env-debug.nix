{pkgs}: (pkgs.buildEnv {
  name = "root";
  paths = with pkgs; [
    bashInteractive
    uutils-coreutils-noprefix
    # network debugging utils
    curl
    bind.dnsutils
    # local host / process debugging utils
    htop
  ];
})
