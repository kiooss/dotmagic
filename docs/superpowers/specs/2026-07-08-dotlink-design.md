# dotlink — dotfiles リンク管理コマンド

## 目的

`install/link.sh` を置き換える dotfiles リンク管理ツール `bin/dotlink` を作る。
一括リンク(sync)に加え、`~/.config/<tool>/` を dotfiles 管理下に取り込む(add)/
降ろす(unlink)操作を提供する。完成後 `link.sh` は廃止し、`bin/dotmagic` からの
呼び出しも `dotlink sync` に差し替える。

### スコープ外(別サイクルで扱う)

- `bin/dotmagic` の廃止、および pull / submodule / install 機能の `dotlink` への移行。
  今回 `dotmagic` はそのまま残し、内部の `link.sh` 呼び出しだけ `dotlink sync` に差し替える。

## 配置

- `bin/dotlink` — PATH 上の他 `bin/` スクリプトと同様、bare で実行可能。
- 言語は bash(既存 `bin/` スクリプトと同様。連想配列などは使わず素直に書く)。

## サブコマンド

| コマンド | 動作 |
|---|---|
| `dotlink sync [--force]` | `link.sh` 相当の一括リンク。`link/*.symlink`→`~/.<name>`、`dotconfig/*`→`~/.config/`、`config.mac/*`→`~/.config/`(mac時)。`--force` で既存実体を `~/.backup/` へ退避してから再リンク。 |
| `dotlink add <tool> [--mac]` | `~/.config/<tool>/` を dotfiles へ取り込む。デフォルト `dotconfig/<tool>/`、`--mac` で `config.mac/<tool>/`。move + シンボリックリンク。 |
| `dotlink unlink <tool>` | `add` の逆操作。リンクを外し、dotfiles 内実体を `~/.config/<tool>/` へ move back。dotfiles からは実体が消える。 |

## `add <tool> [--mac]` フロー

1. `dest` = `--mac` なら `config.mac/<tool>`、それ以外 `dotconfig/<tool>`。
2. `~/.config/<tool>` が既に dotfiles 内実体へのリンク → 「既に管理済み」と表示してスキップ(冪等)。
3. `~/.config/<tool>` が存在しない → エラー終了(取り込む実体がない)。
4. `~/.config/<tool>` がディレクトリでない(通常ファイル等)→ エラー終了。`unlink` は実体を `-d` で探すため、ファイルを取り込むと戻せなくなる。
5. `dest` が既に存在(別マシンで取り込み済み)→ ローカルの `~/.config/<tool>` を `~/.backup/` へ退避。
6. それ以外 → `~/.config/<tool>` を `dest` へ move。
7. `~/.config/<tool>` → `dest` へシンボリックリンクを張る。

## `unlink <tool>` フロー

1. `dotconfig/<tool>` と `config.mac/<tool>` のどちらに実体があるか探索(どちらにも無ければエラー終了)。
2. `~/.config/<tool>` のリンクを外す。
3. dotfiles 内実体を `~/.config/<tool>/` へ move back。
4. git 操作はしない。実体は git 管理下なので、ユーザーが後で `git rm` / commit する。
   コマンドは working tree の move のみ行う。

## 共通仕様

- 対象は `~/.config/<tool>/` **ディレクトリのみ**。単一ファイル系(`link/*.symlink`)は
  `sync` の一括リンクでのみ扱い、`add`/`unlink` の対象外。
- `~/.backup/` は既存同様、必要時に `mkdir -p`。
- `sync` の中核リンクロジックは `link.sh` の `link_config` を移植し、`add`/`sync` で共有する。
- エラーメッセージ・絵文字スタイルは既存 `link.sh` を踏襲。
- 未知のサブコマンド / 引数不足には usage を表示して非ゼロ終了。

## エッジケースまとめ

| 状況 | 挙動 |
|---|---|
| `add`: 既にリンク済み | スキップ(冪等) |
| `add`: `~/.config/<tool>` が無い | エラー終了 |
| `add`: `dest` が既に存在 | ローカルを `~/.backup/` へ退避してからリンク |
| `unlink`: dotfiles に実体が無い | エラー終了 |

## 移行

- `bin/dotmagic:92` の `source $DOTFILES/install/link.sh` を `$DOTFILES/bin/dotlink sync` に差し替え。
  (`sync` は `--force` 無しで、既存 `source .../link.sh`(引数なし=非force)と同じ挙動。)
- `install/link.sh` を削除。
- `CLAUDE.md` の `install/link.sh` 記述を `bin/dotlink` に更新。
- `dotmagic` 自体は今回は残す(別サイクルで廃止)。

## テスト / 検証

自動テストは無いリポジトリなので、手動検証で確認する:

- `dotlink sync` を実行し、`link.sh` と同じリンク結果になること(既存リンクは「already linked」表示)。
- テスト用ダミー `~/.config/dotlink-test/` を作って `add dotlink-test` → リンク化を確認 →
  `unlink dotlink-test` で元のディレクトリに戻ることを確認。
- `--mac` 付き add が `config.mac/` へ入ること。
- 存在しない tool の add、既にリンク済みの add がそれぞれ正しくエラー/スキップになること。
