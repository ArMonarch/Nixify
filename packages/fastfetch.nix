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
  flashfetchSupport ? false,
  imageSupport ? false,
  zfsSupport ? false,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "2.43.0";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    tag = finalAttrs.version;
    hash = "sha256-gUqNiiPipoxLKwGVsi42PyOnmPbfvUs7UwfqOdmFn/E=";
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
    (lib.cmakeBool "BUILD_FLASHFETCH" flashfetchSupport)

    (lib.cmakeBool "ENABLE_LIBZFS" zfsSupport)
    (lib.cmakeBool "ENABLE_IMAGEMAGICK6" false)
    (lib.cmakeBool "ENABLE_IMAGEMAGICK7" imageSupport)
    (lib.cmakeBool "ENABLE_CHAFA" imageSupport)
  ];

  postPatch = ''
    substituteInPlace completions/fastfetch.{bash,fish,zsh} --replace-fail python3 '${python3.interpreter}'
  '';

  postInstall = ''
    wrapProgram $out/bin/fastfetch \
    --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
  ''
  + lib.optionalString flashfetchSupport ''
    wrapProgram $out/bin/flashfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
  '';

  postFixup = ''
    # remove default fish completions and add new fish completions
    # as default fish completions doesn't seem to work
    rm -r $out/share/fish
    mkdir -p $out/share/fish/completions
    ln -vsf $src/completions/fastfetch.fish $out/share/fish/completions/fastfetch.fish
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "An actively maintained, feature-rich and performance oriented, neofetch like system information tool";
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    changelog = "https://github.com/fastfetch-cli/fastfetch/releases/tag/${finalAttrs.version}";
  };
})
