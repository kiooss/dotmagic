# pull-request — リリース PR 作成コマンド(再設計)

## 目的

`bin/pull-request` を作り直す。用途は旧版と同じ「ステージング/本番リリース
PR の作成」だが、実装をモダンかつシンプルにする。旧版が抱えていた次の問題を
根本から取り除く:

- `--head develop` のハードコード(現在ブランチと無関係な PR が作られる実バグ)
- `<project>-develop` → `<project>-staging` のプロジェクト接頭辞抽出ロジックの複雑さ
- `get_diff`(`git log | grep | sed`)+ `REF_BASE_URL` によるチケット URL 化 —
  `set -e` とパイプの相互作用でエラーが隠れる、未設定環境変数で挙動が変わる
- 11 行のコメントアウト済みデッドコード

## スコープ

`bin/pull-request` 単一ファイルの全面書き換え。既存の `bin/lib/colors.sh`
(色付き出力ライブラリ)は引き続き利用する。

## コマンド体系

| コマンド | 動作 |
|---|---|
| `pull-request staging` | 現在ブランチ → ステージングブランチへリリース PR を作成 |
| `pull-request production` | 現在ブランチ → 本番ブランチへリリース PR を作成 |
| `pull-request init` | リリース用ラベル2種を作成(新規リポジトリで一度だけ) |
| (その他/引数なし) | usage を表示して非ゼロ終了 |

明示的なサブコマンド方式を採用(本番操作をうっかり実行しないため、`production`
は明示タイプを要求)。

## 設定(git config、リポジトリごと)

ブランチ名・ラベル名は git config で上書き可能。未設定時は既定値を使う。

| キー | 既定値 | 用途 |
|---|---|---|
| `pull-request.stagingBranch` | `staging` | staging PR の base |
| `pull-request.prodBranch` | `production` | production PR の base |
| `pull-request.stagingLabel` | `staging-release` | staging PR に付けるラベル |
| `pull-request.prodLabel` | `production-release` | production PR に付けるラベル |

読み出しは `git config --get <key>`、値が無ければシェル側で既定値を代入する
(`git config --get key || echo default` ではなく、`${VAR:-default}` 方式)。

## 動作フロー

### `staging` / `production` 共通
1. **事前バリデーション**(いずれか失敗で明確なエラーメッセージ + 非ゼロ終了):
   - git リポジトリ内か(`git rev-parse --is-inside-work-tree`)
   - `gh` コマンドが使えるか(`command -v gh`)
   - detached HEAD でないか(`git symbolic-ref --quiet HEAD`)— 現在ブランチが
     head になるため必須
   - base ブランチ(staging/prod)がローカルまたはリモートに存在するか
2. `head` = 現在のブランチ(`git symbolic-ref --short HEAD`)
3. `base` = 設定値(既定 staging / production)
4. `label` = 設定値(既定 staging-release / production-release)
5. `git up`(既存の `bin/git-up`)で最新化 — 旧版踏襲。失敗しても PR 作成は続行
   できるべきなので、エラーは警告に留める(`git up || true` 相当)
6. 確認表示(色付き): head、base、label
7. `gh pr create --base "$base" --head "$head" --label "$label" --fill`

### `init`
- `gh label create <stagingLabel> -f -d "Staging release" -c "#0052CC"`
- `gh label create <prodLabel> -f -d "Production release" -c "#B60205"`
- ラベル名は設定値を使う(ブランチ設定と一貫)

## 捨てるもの(旧版からの削除)

- project 接頭辞抽出(`current_branch =~ (.*)-develop`)と `<project>-staging` 等
- `get_diff` 関数、`REF_BASE_URL`、`PULL_REQUEST_AUTHOR_PATTERN`、チケット URL 化
- `DIFF_ONLY` 環境変数
- `--head develop` ハードコード → 現在ブランチに
- コメントアウト済み旧実装(11 行)
- `master` フォールバック(base はすべて設定値に一本化)

## 本文生成

`gh pr create --fill` に一本化。base..head のコミットから gh が自動生成する。
チケット抽出・URL 化は行わない。

## エラーハンドリング方針

- スクリプト冒頭で `set -euo pipefail`
- バリデーション失敗は `colors.sh` の `RED` で理由を明示し非ゼロ終了
- `git up` の失敗のみ非致命(警告表示して続行)

## テスト / 検証

自動テストの無いリポジトリなので手動検証:

- `bash -n bin/pull-request` — 構文チェック
- `pull-request`(引数なし)/ 不正サブコマンド → usage + 非ゼロ終了
- git リポジトリ外での実行 → エラー終了
- detached HEAD(`git checkout <sha>`)での `staging` 実行 → エラー終了
- 使い捨てリポジトリで `pull-request.stagingBranch` を設定 →
  `git config --get` で正しく読めること、既定値フォールバックも確認
- 実際の PR 作成は破壊的なので、`gh pr create` の直前までを dry-run 相当で確認
  (組み立てられる base/head/label を echo で検証)、または throwaway リポジトリで実行

## 未解決事項

なし。
