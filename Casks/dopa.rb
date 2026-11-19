cask "dopa" do
  version "0.3.6"
  sha256 "3d82d1d622c499429981e90a8fd51eac4c88bb2befacb84daeeebb0bbd0da48f"

  url "https://github.com/gw31415/dopa/releases/download/v#{version}/Dopa-macos-arm64.zip"
  name "Dopa"
  desc "Prevent system sleep only when needed"
  homepage "https://github.com/gw31415/dopa"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Dopa.app"
  binary "#{appdir}/Dopa.app/Contents/Helpers/dopa"
  binary "#{appdir}/Dopa.app/Contents/Helpers/dopa-daemon"
  bash_completion "#{appdir}/Dopa.app/Contents/Resources/completions/dopa.bash", target: "dopa"
  bash_completion "#{appdir}/Dopa.app/Contents/Resources/completions/dopa-daemon.bash", target: "dopa-daemon"
  zsh_completion "#{appdir}/Dopa.app/Contents/Resources/completions/dopa.zsh", target: "_dopa"
  zsh_completion "#{appdir}/Dopa.app/Contents/Resources/completions/dopa-daemon.zsh", target: "_dopa-daemon"
  fish_completion "#{appdir}/Dopa.app/Contents/Resources/completions/dopa.fish"
  fish_completion "#{appdir}/Dopa.app/Contents/Resources/completions/dopa-daemon.fish"
end
