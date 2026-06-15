bottom.yazi

yaziのファイル・フォルダリストを下寄せ・逆順に表示するプラグインです。

## インストール

1. プラグインをyaziのプラグインディレクトリにコピーします：

```bash
cp -r bottom.yazi ~/.config/yazi/plugins/
```

2. `keymap.toml` を `~/.config/yazi/keymap.toml` にコピーします：

```bash
cp keymap.toml ~/.config/yazi/keymap.toml
```

## keymap.toml の設定

このプラグインは描画を上下反転させるため、矢印キーの動作も反転させなければなりません。`keymap.toml` に以下の設定が必要です：

```toml
[[mgr.prepend_keymap]]
on = "<Up>"
run = "arrow 1"
desc = "Move down (reversed for bottom-aligned)"

[[mgr.prepend_keymap]]
on = "<Down>"
run = "arrow -1"
desc = "Move up (reversed for bottom-aligned)"
```

- **上矢印** → カーソルが下に移動（描画が反転しているため）
- **下矢印** → カーソルが上に移動（描画が反転しているため）

## 動作

- ファイルリストがA→Z順で下寄せ表示されます
- カーソルは初期位置で最下位に設定されます
- 親ディレクトリリストも同様に逆順表示されます
