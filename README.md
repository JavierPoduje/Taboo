# Taboo

Taboo is a Neovim plugin that provides a simple API for working with tabs. It allows you to open and close tabs using tab numbers, switch between tabs, and more.

## Installation

Taboo can be installed using a plugin manager such as vim-plug, dein.vim, or packer.nvim.
For example, if you're using vim-plug, you can add the following line to your init.vim or init.lua:

```vim
Plug 'JavierPoduje/taboo'
```

Then run :PlugInstall to install the plugin.

TODO: add packer as an example

## Usage

### Opening tabs
To open a new tab with a specific tab number, you can use the TabooOpenTab() function. For example, to open a new tab with the number 3, you can run:

```vim
:lua require('taboo').TabooOpenTab(3)
```
If the tab already exists, the function will switch to that tab instead of opening a new one.

### Closing tabs

To close a tab with a specific tab number, you can use the TabooCloseTab() function. For example, to close the tab with the number 3, you can run:

```vim
:lua require('taboo').TabooCloseTab(3)
```
If the tab does not exist, the function will do nothing.

### Switching tabs
To switch to a tab with a specific tab number, you can use the TabooSwitchTab() function. For example, to switch to the tab with the number 3, you can run:

```svim
:lua require('taboo').TabooSwitchTab(3)
```
If the tab does not exist, the function will do nothing.

### Getting the current tab number

To get the number of the current tab, you can use the TabooGetCurrentTab() function. For example, to print the current tab number to the console, you can run:

```vim
:lua print(require('taboo').TabooGetCurrentTab())
```

### Getting the total number of tabs
To get the total number of tabs, you can use the TabooGetTabCount() function. For example, to print the total number of tabs to the console, you can run:

```vim
:lua print(require('taboo').TabooGetTabCount())
```

## Configuration

Todo: ...

## License

Taboo is licensed under the MIT license. See the LICENSE file for details.

## Contributing

Contributions to taboo are welcome! If you have an idea for a feature or a bug fix, feel free to open an issue or submit a pull request.
Please follow the existing code style and conventions (TODO), and be sure to write tests for any new functionality.

## Credits

Taboo was created by Javier Poduje (@JavierPoduje).
