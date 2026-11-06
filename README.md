# zane-nvim

[Zane](https://github.com/zane-lang/compiler) support for Neovim:

- `.zn` and `.zane` files get the `zane` filetype;
- Tree-sitter highlighting starts in them, including each use of a
  parameter (through the plugin's `zane-bound?` query predicate);
- the Zane parser is registered with
  [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter), which
  downloads the grammar and highlight queries from `zane-lang/compiler`, builds
  the parser and installs both. The plugin starts that install the first time
  a Zane file is opened without a parser.

The grammar is not part of this plugin: it comes from the compiler, so the
parser and its queries always come from the same compiler version.

## Requirements

- Neovim 0.11 or newer
- nvim-treesitter, `main` branch
- the [Tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli),
  a C compiler, `curl` and `tar`, which nvim-treesitter uses to install
  parsers. Node is not needed.

## Install

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "TheLazyCat00/zane-nvim", lazy = false }
```

With Neovim 0.12's built-in `vim.pack`:

```lua
vim.pack.add({ "https://github.com/TheLazyCat00/zane-nvim" })
```

Open a `.zn` file and the parser installs. Don't put `"zane"` in the list you
give to `require("nvim-treesitter").install()`: nvim-treesitter may read that
list before this plugin has registered the parser. `:TSUpdate` (or
`:TSUpdate zane`) fetches the compiler's current grammar and queries again;
restart Neovim afterwards, since a loaded parser is not replaced.

## Options

```lua
require("zane").setup({
  -- Install the parser the first time a Zane file is opened without one.
  -- When false, run :TSInstall zane yourself.
  auto_install = true,
})
```

With lazy.nvim, pass them as `opts`.

`:checkhealth zane` checks the setup.

## Development

The highlight queries, and the arguments `zane-bound?` receives, are generated
in `zane-lang/compiler` (`editors/neovim/queries/highlights.scm`, from
`grammar/tree-sitter.coda`); that repository's highlighting tests run Neovim
with this plugin.
