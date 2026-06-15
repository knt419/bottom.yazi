bottom.yazi

yaziのファイル・フォルダリストを下寄せ・逆順に表示するプラグインです。

## インストール

1. プラグインをインストールします：

```bash
ya pkg add knt419/bottom
```

2. `~/.config/yazi/init.lua` に以下の行を追加します：

```lua
require("bottom"):setup()
```

3. `~/.config/yazi/keymap.toml` に矢印キーを反転させる設定を追加します：

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
