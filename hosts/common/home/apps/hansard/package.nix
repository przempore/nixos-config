{ lib, buildNpmPackage, fetchurl, nodejs_24, python3 }:

(buildNpmPackage.override { nodejs = nodejs_24; }) rec {
  pname = "hansard";
  version = "0.8.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/hansard/-/hansard-${version}.tgz";
    hash = "sha256-akBzed00Ak8RSlWN4R94xHVXgPTFMG+jG6uRwmojuMM=";
  };

  npmDepsHash = "sha256-E2eHcqus7X8Q06pQRktcFT8k9A3mtv/u34pwk1CuyrA=";
  # Upstream's publishing npm version need not match Nixpkgs' npm version.
  postPatch = ''
    ${lib.getExe nodejs_24} -e '
      const fs = require("fs");
      const pkg = JSON.parse(fs.readFileSync("package.json", "utf8"));
      delete pkg.devEngines;
      fs.writeFileSync("package.json", JSON.stringify(pkg));
    '
  '';
  nativeBuildInputs = [ python3 ];
  env.npm_config_build_from_source = "true";
  dontNpmBuild = true;

  meta = {
    description = "Local conversation archive and memory recall for coding agents";
    homepage = "https://www.hansard.dev";
    license = lib.licenses.mit;
    mainProgram = "hansard";
    platforms = lib.platforms.linux;
  };
}
