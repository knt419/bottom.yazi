# bottom.yazi

A yazi plugin that displays the file/folder list in reverse order, aligned to the bottom.

## Installation

1. Install the plugin:

```bash
ya pkg add knt419/bottom
```

2. Add the following line to `~/.config/yazi/init.lua`:

```lua
require("bottom"):setup()
```

3. Add the following configuration to `~/.config/yazi/keymap.toml` to reverse arrow key behavior:

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

- **Up arrow** → Cursor moves down (because rendering is reversed)
- **Down arrow** → Cursor moves up (because rendering is reversed)

## Behavior

- File list is displayed in A→Z order, aligned to the bottom
- Cursor is initially positioned at the last item
- Parent directory list is also displayed in reverse order

---

# bottom.yazi

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
