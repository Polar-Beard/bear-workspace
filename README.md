## Setting Up a Bear Workspace

This workspace is optimized for bear development. If you're a human, this just
isn't for you. Feel free to try, but a lot of what goes on in this repo won't
make any sense, and you're going to feel lost, a little scared, and very very
hungry.

If you're a bear, congratulations, you good-looking animal! Follow these steps to
get a workspace that works well, looks great, and is up to bear standards.

This will give you a few things:
- Ubuntu WSL
- Hyper.js
- Powerline Optmized Fonts

## Install Ubuntu on Windows Subsystem linux
This is taken from this website: https://docs.microsoft.com/en-us/windows/wsl/install-win10
1. Open PowerShell as Administrator and run:
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
2. Restart your computer when prompted.
3. Install Ubuntu for Windows. Just go to the Microsoft store, you cute little creature
4. Launch Ubuntu, and  go through the unix user set up instructions
5. Do you have an ugly computer name? Let's go fix that

![Ugly Computer Name](images/ugly_computer_name.png?raw=true "Ugly Computer Name")

*Pictured above: ugly computer name*

## Fix Ugly Computer Name
1. Search for "About your PC"
2. Click "Rename this PC"
3. Type in your sexy new name
4. Restart your computer

## Set Up HyperJS
Oh my good, you are adorable. Go get that Hyper JS, you fluffy son of a bitch.

1. Install HyperJS: https://hyper.is/
2. Install a pretty little theme for yourself:
`hyper install hyper-snazzy`
3. Bear out a little

![Bear Out](images/bear_out.gif?raw=true "Bear Out")

4. Update Hyper to start Ubuntu by default when launched
- Hit `Ctrl` +  `,` to open the HyperJS settings
-  Scroll down to shell and change it to `C:\\Windows\\System32\\bash.exe`
```diff
- shell: '',
+ shell: 'C:\\Windows\\System32\\bash.exe',
```

## Run Magic Script

Wow, you're so pretty. That fur, what sheen. Your color, your coat. Wonderful.
Let's keep working though, we'll have time to frolic later. 

1. Run `./fix-wsl-permissions.sh` to fix a bug in WSL where permissions default
   to 0777
1. Reload the terminal
1. Run `./bear-with-me.sh`
1. Restart your computer
1. Rock on

## Install Powerline Fonts
Man, those paws are perfect. Round, soft, powerful. *sigh*. Let's install powerline, so our console can go from this

![No Powerline](images/no_powerline.png?raw=true "No Powerline")

To this: 

![Powerline](images/powerline.png?raw=true "Powerline")

1. Download the zip from the [Powerline Github page](https://github.com/powerline/fonts) 
1. Extract all from the zip
1. Open a Powershell as Administrator
1. Navigate to `fonts-master` directory: `cd "${HOME}\Downloads\fonts-master\fonts-master"`
1. Change the `Execution Policy`: `Set ExecutionPolicy Bypass`
1. Run `.\install.ps1` script to install the fonts
1. Change your Hyper font to `Fira Mono for Powerline`

A place for bears

### References
https://medium.com/@Andreas_cmj/how-to-setup-a-nice-looking-terminal-with-wsl-in-windows-10-creators-update-2b468ed7c326
https://www.turek.dev/post/fix-wsl-file-permissions/

 ```diff
 prompt_context() {                                              
   if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
-    prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m"    
+    prompt_segment 5 15 "%(!.%{%F{yellow}%}.)%n@%m"        
   fi                                                            
 }
 ```
