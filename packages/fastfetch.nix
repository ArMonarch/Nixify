{
  chafa,
  cmake,
  imagemagick,
  installShellFiles,
  makeBinaryWrapper,
  python3,
  pkg-config,
  yyjson,
  zfs,
  zlib,

  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,

  # Feature flags
  imageSupport ? true,
  zfsSupport ? true,
  shellCompletions ? true,
  ...
}:
stdenv.mkDerivation (finalAttr: {
  pname = "fastfetch";
  version = "2.56.1";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    tag = finalAttr.version;
    hash = "sha256-loTEadHPhE0b7VYCq2Lh+FKKnqzc4kzWFkHLnTjFsBg=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    installShellFiles
    pkg-config
    python3
  ];

  buildInputs =
    let
      commonDeps = [ yyjson ];
      zfsDeps = lib.optionals zfsSupport [ zfs ];
      imageDeps = lib.optionals imageSupport [
        chafa
        imagemagick
      ];
      linuxFeatureDeps =
        let
          imageDeps = lib.optionals imageSupport [ zlib ];
        in
        lib.optionals stdenv.hostPlatform.isLinux imageDeps;
    in
    commonDeps ++ imageDeps ++ zfsDeps ++ linuxFeatureDeps;

  cmakeFlags = [
    (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_SYSCONFDIR" "${placeholder "out"}/etc")
    (lib.cmakeBool "ENABLE_DIRECTX_HEADERS" false)
    (lib.cmakeBool "ENABLE_SYSTEM_YYJSON" true)

    # Feature flags
    (lib.cmakeBool "ENABLE_LIBZFS" zfsSupport)
    (lib.cmakeBool "ENABLE_IMAGEMAGICK6" false)
    (lib.cmakeBool "ENABLE_IMAGEMAGICK7" imageSupport)
    (lib.cmakeBool "ENABLE_CHAFA" imageSupport)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ ];

  postPatch = ''
    substituteInPlace completions/fastfetch.{bash,fish,zsh} --replace-fail python3 '${python3.interpreter}'
  '';

  postInstall = ''
    wrapProgram $out/bin/fastfetch \
    --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttr.buildInputs}"
  '';

  postFixup = ''
    for shell in bash fish zsh; do
      installShellCompletion --$shell $src/completions/fastfetch.$shell
    done
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "An actively maintained, feature-rich and performance oriented, neofetch like system information tool";
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    changelog = "https://github.com/fastfetch-cli/fastfetch/releases/tag/${finalAttr.version}";
  };
})
