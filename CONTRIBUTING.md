# Contributing

## Cask の変更

- Cask は `Casks/<cask-token>.rb` に置き、ファイル名と `cask "<cask-token>" do`
  の token を一致させてください。
- 他 Tap と token が衝突しそうな場合は `gw31415-<app-name>` のように GitHub
  ユーザー名を接頭辞にしてください。
- 安定版の URL には固定した `version` と SHA-256 の `sha256` を指定してください。
- Apple Silicon と Intel で配布物が異なる場合は `arch` または `on_arm` / `on_intel`
  を使って分岐してください。
- 自動更新アプリには、アンインストール後の関連データを整理できる `zap` stanza の
  追加を検討してください。
- 更新検知が可能なら `livecheck` を追加してください。
- 新規追加や更新の前に `script/check` を実行してください。

`sha256 :no_check` は、公式に固定チェックサムを提供できない自動更新 URL など、
Homebrew が認める場合に限って使用してください。

## Pull request

Pull request の説明には、少なくとも次の内容を含めてください。

- 追加または更新したバージョン
- 配布元の公式 URL
- macOS でのインストール・起動・アンインストールの確認結果
