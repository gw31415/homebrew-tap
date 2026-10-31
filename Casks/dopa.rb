cask "dopa" do
  version "0.3.5"
  sha256 "2f2a1baff5c96e117a008d21b4915598fb9185a3d6ce577b865d4c31c423cb47"

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
