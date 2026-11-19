# shellcheck shell=bash disable=SC2034
# Who may ask for dopa to be signed (checked against the requesting run).
repo=gw31415/dopa
workflow=.github/workflows/release.yml
events='^release$'
refs='^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
# What to sign: Mach-O files inside the bundle, before the bundle itself
# (Contents/MacOS/dopa-ui is signed with the bundle). These are the CLI
# products of dopa's release/artifacts.json; none needs entitlements.
bundle=Dopa.app
inner=(Contents/Helpers/dopa Contents/Helpers/dopa-daemon)
