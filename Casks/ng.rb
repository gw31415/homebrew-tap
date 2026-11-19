cask "ng" do
  version :latest
  sha256 :no_check

  url "https://github.com/gw31415/ng/releases/download/nightly/ng-macos-arm64.zip"
  name "ng"
  desc "Neovim GUI client (unofficial nightly build)"
  homepage "https://github.com/gw31415/ng"

  depends_on arch: :arm64
  depends_on formula: %w[fontconfig freetype neovim sdl3]
  depends_on :macos

  app "ng.app"

  caveats <<~EOS
    This macOS build of ng is unofficial and lives only in gw31415/ng.
    Please do not report macOS problems to Shougo/ng.

    It is a rolling nightly build without version numbers. To update it:
      brew upgrade --cask --greedy-latest ng

    ng.app starts nvim from a zsh login shell, so nvim must be on the
    PATH that "zsh -l" sets up.
  EOS
end
