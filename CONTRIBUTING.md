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
- 新規追加や更新の前に、必要に応じて `script/check` をローカルで実行してください。

`sha256 :no_check` は、公式に固定チェックサムを提供できない自動更新 URL など、
Homebrew が認める場合に限って使用してください。

## Pull request

`dopa` のリリース Pull Request は、配布元リポジトリの release workflow が、
ビルド・SHA-256・manifest・Homebrew Cask のインストール・起動・アンインストールを
検証した後に自動作成します。この Tap には GitHub Actions がないため、検証は
Pull Request を作成する前に完了しています。レビューでは次を確認してください。

- 追加または更新したバージョンが対象リリースと一致していること
- 配布元の公式 URL と変更ファイルが意図したものだけであること
- workflow の検証結果が成功していること

SHA-256 は workflow が自動検証した値を使用するため、レビュアーが手元で再計算する
必要はありません。内容を確認したら、`@gw31415` が Pull Request を承認します。
auto-merge が予約済みのため、必須条件がそろうと自動で merge されます。

手動で Cask を変更する場合も、`script/check` はローカル用の Homebrew 構文・style
チェックとして利用できます。repository 所有者の admin bypass は、このような手動保守と
初回設定のためだけに使用し、通常の Dopa リリースでは使用しません。
