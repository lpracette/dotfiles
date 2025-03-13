# My dot files

My dotfiles for macos, managed with [GNU Stow](https://www.gnu.org/software/stow/).

see [install.sh](https://github.com/lpracette/dotfiles/blob/master/install.sh)


## Quick oneliner for a very basic vim config
```console
echo "colo slate|set nu|set et|set ts=4|set nowrap|set hls|set is|inoremap jk <esc>" > ~/.vimrc
```
|Command               |Explanation                                                                             |
|----------------------|----------------------------------------------------------------------------------------|
|``colo slate``        |Load color scheme 'slate'.                                                             |
|``set nu``            |Precede each line with its line number.                                                 |
|``set et``            |Use the appropriate number of spaces to insert a ``<Tab>``.                             |
|``set ts=4``          |Number of spaces that a ``<Tab>`` in the file counts for.                               |
|``set nowrap``        |Lines longer than the width of the window will not wrap.                                |
|``set hls``           |When there is a previous search pattern, highlight all its matches.                     |
|``set is``            |While typing a search command, show where the pattern, as it was typed so far, matches. |
|``inoremap jk <esc>`` |Remap jk to ``<esc>`` in insert mode.                                                   |
