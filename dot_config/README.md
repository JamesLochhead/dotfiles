# External dependencies

- `npm` for the NeoVim plugin Coc.
- `universal-ctags` for the NeoVim plugin Vista.
- `xclip` or `xsel` for NeoVim system clipboard on Linux.
- `pbcopy` and `pbpaste` for NeoVim system clipboard on MacOS.
- ALE plugs in to various external linters and fixers.

| Package name | Source |
|--------------|--------|
| autopep8     | pip    |
| cfn-lint     | pip    |
| prettier     | npm    |
| pylint       | pip    |
| yapf         | pip    |

# Coc

Current Coc extensions are listed in `dot_config/coc/extensions/package.json`.

These are currently installed manually via `:CocInstall EXTENSION1 EXTENSION2`
within NeoVim.
