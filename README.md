## Setup wsl (run as admin)

```bash
Set-ExecutionPolicy RemoteSigned;
wsl --unregister Debian;
wsl --install --no-launch -d Debian;
debian install --root;
debian run "useradd -m -s /bin/bash $Env:UserName";
debian run "passwd -d mp281x && usermod -aG sudo $Env:UserName";
debian config --default-user $Env:UserName;
debian run "sudo apt-get install curl -y > /dev/null";
debian run "bash <(curl -s -L https://raw.githubusercontent.com/MP281X/dotfiles/main/scripts/setup.sh)";
```

## Vscode extensions

##### linter - formatter
- Prettier
- Eslint

##### themes
- Horizon Theme
- Material Icon Theme

##### lsp
- Svelte for VS Code
- Tailwind CSS Intellisense

##### tools
- Excalidraw
- Sql Notebook

##### utils
- Error Lens
- Better Comments
- TwoSlash Query Comments
- Pretty Typescript Errors
- Template String Converter
