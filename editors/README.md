# Favorite Editors

## [Vim](https://vim.org)

### Plugins

The following plugins and more are installed by default using [Vundle](https://github.com/VundleVim/Vundle.vim):

```viml
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-surround'
Plugin 'airblade/vim-gitgutter'

Plugin 'scrooloose/syntastic'
Plugin 'elzr/vim-json'
Plugin 'plasticboy/vim-markdown'
Plugin 'fatih/vim-go'
Plugin 'ekalinin/dockerfile.vim'
```

Just comment it out if you find the plugin you do not want to install.

### Configurations

I am not a big fan of Vim and tring to keep its configuration as simple as possible.

```viml
" Enable syntax highlighting
syntax on

" Color cloumn settings for Git commit length
set cc=51,73,81,121
highlight ColorColumn ctermbg=17 guibg=navyblue
```

## [Atom](https://atom.io)

### Plugins

The following plugins and more are installed:

```bash
PLUGINS=(
  AtomicChar
  sync-settings
  auto-update-packages
  project-manager
  file-icons
  linter
  linter-docker
  linter-shellcheck
  linter-haproxy
  file-icons
  minimap
  expose
  git-time-machine
  todo-show
  terminal-plus
  recent-files-fuzzy-finder
  zentabs
  language-markdown
  )
```

 Just comment it out if you find the plugin you do not want to install.
