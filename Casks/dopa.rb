cask "dopa" do
  version "0.3.2"
  sha256 "f7484a6489506801c57560660c4757b2332909c8b47ae9526de6c471f4e7e005"

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
  fish_completion "#{appdir}/Dopa.app/Contents/Resources/completions/dopa.fish"
  fish_completion "#{appdir}/Dopa.app/Contents/Resources/completions/dopa-daemon.fish"
  zsh_completion "#{appdir}/Dopa.app/Contents/Resources/completions/dopa.zsh", target: "_dopa"
  zsh_completion "#{appdir}/Dopa.app/Contents/Resources/completions/dopa-daemon.zsh", target: "_dopa-daemon"

  caveats <<~EOS
    Dopa is ad-hoc signed without a Developer ID and is not notarized by Apple.
    macOS may block it after installation or upgrade.

    After trying to open Dopa once, allow it in:
      System Settings > Privacy & Security > Open Anyway

    Or, only if you trust this release, remove quarantine from Dopa alone:
      xattr -dr com.apple.quarantine "#{appdir}/Dopa.app"
      open "#{appdir}/Dopa.app"

    Do not use a wildcard: removing quarantine bypasses Apple's malware check.
  EOS
end
