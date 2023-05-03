# My Visual Studio Code's Themes

It's my personal vscode's themes.

Forked [Rouge theme](https://github.com/josefaidt/rouge-theme)

## For more information

* [Create Color Theme](https://code.visualstudio.com/api/extension-guides/color-theme)
* [Visual Studio Code's Markdown Support](http://code.visualstudio.com/docs/languages/markdown)
* [Markdown Syntax Reference](https://help.github.com/articles/markdown-basics/)


## What's in the folder

* This folder contains all of the files necessary for your color theme extension.
* `package.json` - this is the manifest file that defines the location of the theme file and specifies the base theme of the theme.
* `themes/naki01-color-theme.json` - the color theme definition file.

## Get up and running straight away

* Press `F5` to open a new window with your extension loaded.
* Open `File > Preferences > Color Themes` and pick your color theme.
* Open a file that has a language associated. The languages' configured grammar will tokenize the text and assign 'scopes' to the tokens. To examine these scopes, invoke the `Inspect TM Scopes` command from the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P` on Mac) .

## Make changes

* Changes to the theme file are automatically applied to the Extension Development Host window.

## Adopt your theme to Visual Studio Code

* The token colorization is done based on standard TextMate themes. Colors are matched against one or more scopes.

To learn more about scopes and how they're used, check out the [color theme](https://code.visualstudio.com/api/extension-guides/color-theme) documentation.

## Install your extension

* To start using your extension with Visual Studio Code copy it into the `<user home>/.vscode/extensions` folder and restart Code.
* To share your extension with the world, read on https://code.visualstudio.com/docs about publishing an extension.
* 윈도우즈 심볼링크 만들기 예 (cmd.exe):
  ```bash
  mklink /d "C:\Users\naki\.vscode\extensions\naki-theme" "C:\Users\naki\projects\mydevenv\vscode\naki-theme"
  ```
* Make linux symbolic link:
  ```bash
  ln -s ~/projects/mydevenv/vscode/naki-theme ~/.vscode/extensions/naki-theme
  ```