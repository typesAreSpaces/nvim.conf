# Neovim configuration

Personal Neovim configuration using lazy.nvim, nvim-cmp, UltiSnips, Telescope,
Treesitter, and the built-in LSP client.

## Requirements

- Neovim 0.11.3 or newer; reviewed with Neovim 0.12.6.
- Git for lazy.nvim bootstrap and plugin installation.
- A C compiler for Treesitter parser builds. The legacy `master` branch is
  intentional: the configuration uses its module API and includes a Neovim 0.12
  query compatibility adapter. Migrating to the rewritten branch requires
  replacing that configuration and the playground integration together.
- Python 3 with `pynvim` for UltiSnips and Wilder. Install it in the Python
  interpreter used by Neovim; inspect `:checkhealth provider.python` if needed.
  Set `vim.g.python3_host_prog` before lazy.nvim setup if auto-detection chooses
  the wrong interpreter. Wilder's remote-plugin registration runs on install.
- `rg` for Telescope live grep; `fd` is optional for file discovery.
- A Nerd Font for tabline, statusline, and explorer icons.

Install optional tools for the features you use:

| Feature | External tools |
| --- | --- |
| Python LSP | `pyright-langserver` from Pyright |
| C/C++ LSP | `clangd` |
| LaTeX LSP | `texlab` |
| `:RuffCheck` | `uv`, with Ruff available through `uv run ruff` in the project |
| VimTeX | TeX distribution, `latexmk`, Sioyek, and `nvr` from `neovim-remote` |
| Markdown preview | Node.js; the plugin build hook installs its preview server |
| Minimap | `code-minimap` |
| Grammar checking | Java and Grammarous's LanguageTool setup |
| Debugging | Vimspector adapters for the target language |

Language servers are installed externally, not managed by this configuration.
The Sioyek application bundle under `/Applications` is detected when its binary
is absent from `PATH`. On a fresh install, run `:Lazy sync`; if Markdown Preview
was already installed without its server, run `:Lazy build markdown-preview.nvim`.
Use `:checkhealth` to inspect machine-specific dependencies. Keep `lazy-lock.json`
under version control to reproduce plugin versions; use `:Lazy restore` to return
installed plugins to those revisions. Update the lockfile alongside deliberate
plugin updates.

## Behavior and customization

- The leader and local leader are Space.
- In insert mode, Ctrl-Space requests completion. With the menu visible, it
  expands an available snippet or selects the next item; Ctrl-J confirms.
- Oil is the default directory explorer. NvimTree and Telescope's file browser
  remain available through their commands and existing mappings.
- NvimTree, Minimap, and Vimspector load on demand. Vimspector commands,
  `<Plug>` mappings, and direct `vimspector#...` function calls trigger loading.
  Inactive themes load when selected with `:colorscheme`.
- Completion and UltiSnips initialize on the first InsertEnter; Wilder initializes
  on the first command-line entry. Python initialization is deferred to features
  that need it, so the first snippet/completion use can still take noticeable time.
  Wilder coalesces rapid input over 75 ms before requesting Python completions.
- Overseer, ZenMode, Undotree, grammar checking, presentations, and animations
  load through their commands. Language-server configurations and extra syntax
  plugins load only for their supported filetypes. LSP capabilities do not load
  the completion engine. Tabby initializes when opening another tab or using
  `:TabRename`/`:Tabby`; its existing rename/reset behavior is preserved.
- Treesitter and VimTeX stay initialized at startup, as their installed versions
  require. The configured parser list includes `markdown_inline` for inline
  Markdown syntax.
- The existing `BufEnter` autocmd intentionally sets each window's working
  directory to the current buffer's directory. `:Make`, `:RuffCheck`, and searches
  therefore run relative to that directory.
- Python overrides live in `after/ftplugin/python.vim`: two-space indentation,
  tab width four, and text width 100, scoped to Python buffers.
- TeX and Markdown file snippets share `pythonx/nvim_snippet_helpers.py`.
  `;input` creates missing files without overwriting existing files. `;intro`
  and `;gloss` append missing entries to `kldb.tex` and `idxdb.tex` in the current
  directory, without external personal scripts.
- `:ReloadConfig` (Space `sc`) reloads core settings, mappings, and commands.
  Existing buffer and window options are preserved; new defaults apply to future
  buffers and windows. To reload one module, use e.g. `:ReloadConfig settings`.
  Restart Neovim after
  editing plugin specifications, plugin configuration, or provider settings.
- `:Make[!] [args]` runs `makeprg` asynchronously through Overseer. A bang keeps
  its quickfix window from opening automatically. `dd` removes an entry from
  the quickfix or location list currently displayed.
- `:RuffCheck` saves files and runs Ruff asynchronously through Overseer, without
  changing the current buffer's `makeprg` or `errorformat`.

Buffers larger than 1 MiB or 20,000 lines skip Treesitter highlighting, incremental
selection, completion, and buffer-word indexing. Regex syntax highlighting is
also disabled for these buffers, including highlighters started by Neovim's own
filetype plugins. Ordinary buffers retain these features when switching back.
Override `vim.g.performance_max_bytes` and `vim.g.performance_max_lines` before
loading the configuration to adjust the limits.

## Verification

Run the focused regression checks without installing plugins:

```sh
python3 -B -m unittest discover -s tests -p 'test_*.py'
nvim --headless -u NONE -i NONE -n -l tests/config.lua
```

After installing plugins, run the integration checks from the repository root:

```sh
nvim --headless -u tests/init.lua -i NONE -n '+luafile tests/integration.lua'
```

The test entry point disables plugin downloads and automatic parser installation.
It checks reloads in Makefile and Python buffers, runs a real Overseer task to
verify diagnostic parsing, checks Ruff task construction without launching uv,
and exercises completion and optional-plugin loading. It uses temporary files
and disables language-server startup.

Check native first-use behavior in separate editor processes:

```sh
for mode in insert command delete yank paste tabs tabnew; do
  NVIM_FIRST_USE=$mode nvim --headless -u tests/init.lua -i NONE -n '+luafile tests/first-use.lua'
done
```

These checks cover the first automatic snippet expansion, command entry,
delete/yank history, pasting, and tab creation/renaming/resetting after lazy loading.

Measure startup and first-use setup with the same installed plugins:

```sh
python3 -B tests/benchmark.py --runs 5 --output /tmp/nvim-benchmark.json
```

The benchmark discards a warm-up launch per scenario, records native Neovim
startup timings, and measures setup triggered by InsertEnter and CmdlineEnter
in fresh processes. First-use timings cover synchronous plugin setup rather than
UI rendering, asynchronous search results, or language-server responses. Keeping
first-use measurements alongside startup results makes deferred work visible.
