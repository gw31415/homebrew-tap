# shellcheck shell=bash disable=SC2034
# Who may ask for ng to be signed (checked against the requesting run).
repo=gw31415/ng
workflow=.github/workflows/release-macos.yml
events='^workflow_dispatch$'
refs='^main$'
# What to sign: Mach-O files inside the bundle, before the bundle itself.
bundle=ng.app
inner=(Contents/MacOS/ng)
