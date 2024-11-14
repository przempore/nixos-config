{ lib, ... }: {
  options = {
    modules = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "Module configuration namespace";
    };
  };
}
