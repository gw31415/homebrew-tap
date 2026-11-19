# gw31415/homebrew-tap

個人配布する macOS アプリ向けの [Homebrew Tap](https://docs.brew.sh/Taps) です。
Homebrew Cask と、必要に応じて Formula を公開できます。

## インストール

Homebrew 6 以降では、非公式 Tap の Cask は明示的な trust が必要です。通常は
完全修飾名を使い、インストールする Cask だけを trust する方法が簡単です。

```sh
brew install --cask gw31415/tap/<cask-token>
```

Tap を先に追加して短い名前で使う場合は、対象 Cask を明示的に trust します。

```sh
brew tap gw31415/tap
brew trust --cask gw31415/tap/<cask-token>
brew install --cask <cask-token>
```

`Brewfile` では次のように指定します。

```ruby
tap "gw31415/tap"
cask "gw31415/tap/<cask-token>"
```

## Cask を追加する

1. このリポジトリを Tap としてローカルに登録します。

   ```sh
   brew tap gw31415/tap "$(pwd)"
   ```

2. 配布物の URL から Cask の雛形を生成します。

   ```sh
   brew create --cask --tap gw31415/tap \
     --set-name <cask-token> \
     https://example.com/path/Example.dmg
   ```

3. `Casks/<cask-token>.rb` の `name`、`desc`、`homepage`、インストール対象の
   `app` などを実際の配布物に合わせて編集します。Cask token は小文字の
   kebab-case を基本にし、他 Tap との衝突を避ける場合は
   `gw31415-<app-name>` のように GitHub ユーザー名を接頭辞にします。

4. ローカル検証を実行します。

   ```sh
   script/check
   ```

5. 実際にインストールとアンインストールを確認します。

   ```sh
   brew install --cask gw31415/tap/<cask-token>
   brew uninstall --cask <cask-token>
   ```

詳細は [Homebrew Cask Cookbook](https://docs.brew.sh/Cask-Cookbook)、
[Acceptable Casks](https://docs.brew.sh/Acceptable-Casks)、
[Tap Trust](https://docs.brew.sh/Tap-Trust) を参照してください。

## Formula

CLI などを配布する場合は `Formula/` に Formula を追加できます。

```sh
brew install gw31415/tap/<formula>
```

## リリース運用

`dopa` のビルド、SHA-256・manifest の照合、Homebrew Cask のインストール・起動・
アンインストール検証は、配布元の
[`gw31415/dopa`](https://github.com/gw31415/dopa) の release workflow が行います。
検証に成功すると、このリポジトリの `Casks/dopa.rb` を更新する Pull Request が
自動作成されます。

Cask の検証のために、この Tap で GitHub Actions は実行しません（この Tap で動くのは、下の「署名と公証」の workflow だけです）。
Pull Request ではバージョン、公式の
配布 URL、変更範囲を確認し、問題がなければ人間が承認します。auto-merge が予約済みのため、
必須条件がそろうと自動で merge されます。SHA-256 は
Dopa 側の workflow で検証済みの値が使われるため、手元で再計算する必要はありません。

`script/check` は、手動で Cask を追加・変更した場合に開発者がローカルで実行する
Homebrew の構文・style チェックです。Tap の自動チェックやリリース処理ではありません。
repository 所有者の admin bypass は初回設定と手動保守のためだけに残し、通常の Dopa
リリースでは使用しません。

`ng` は [`gw31415/ng`](https://github.com/gw31415/ng)（Shougo/ng の非公式 macOS 版）の
ローリングリリース（`nightly`）を配布します。`Casks/ng.rb` は `version :latest` で固定なので、
リリースのたびの更新はありません。更新するには `brew upgrade --cask --greedy-latest ng` を実行します。

## 署名と公証

Developer ID 証明書と公証用の App Store Connect API キーは、この Tap の environment
`apple-signing` にだけ置きます。各アプリ（`ng`、`dopa`）の release workflow は再利用 workflow
`.github/workflows/sign.yml` を呼びます。`sign.yml` は octo-sts で得た短命トークン
（`.github/chainguard/<app>-notarize.sts.yaml`、`actions: write` のみ）を使い、この Tap の
`notarize.yml` を起動します。

`notarize.yml` は、依頼元の run が `notarize/<app>/profile.sh` の条件（リポジトリ、
workflow、イベント、ref）に合うことを確かめてから、その run の未署名 `.app` を受け取り
（読み取り用のトークンは、アプリ側の `.github/chainguard/homebrew-tap-notarize.sts.yaml`
が octo-sts で許可します）、
profile が指す順に署名し、公証して staple します。macOS で動くのは署名・提出と staple だけで、Apple の審査待ちは Ubuntu で行います。条件に合わない依頼は、秘密情報を
読み込む前に失敗します。この Tap でアプリのコードは実行しません。

## License

[MIT](LICENSE)
