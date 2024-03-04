---
title: Setup Flutter on Mac OS
layout: default
---

# [📺 Video](https://easv.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=c2a6f1e2-dca0-4462-96a0-b0d100e54e5b)

# Instructions

## Prerequisite

Open "Terminal" app (search in spotlight).

Type `git` to verify that you have GIT installed.
If you don't it will ask you if you want to install developer tools, go ahead and do that.

If you are on the new Apple Silicon Mac you need to install the translation layer for x86 code.

```sh
sudo softwareupdate --install-rosetta --agree-to-license
```

## Install Flutter-SDK

Now get flutter directly from github

```sh
cd ~
git clone https://github.com/flutter/flutter.git -b stable
```

You need to figure out what shell you are using.

```sh
echo $SHELL
```

Edit `$HOME/.bashrc` or `$HOME/.zshrc` depending on the output.
For the rest if the text I'm going to assume you are using zsh so the shell
config is referred to as `.zshrc`.

You can use either `vim` or `nano` to edit the config.
In `nano` you can save with *Control+o* then exit with *Control+x*.
In `vim` it is *ESCAPE* then type `:wq` .

Add following line at the end of the file:

```sh
export PATH="$PATH:$HOME/flutter/bin"
```

Save and reboot.

Run following command to check flutter dependencies:

```sh
flutter doctor
```

Install **Chrome** if missing.

Don't worry about the other issues for now.

---

## iPhone

If you have an iPhone and would like to be able to build your Flutter projects
for it, then there is a bit of extra setup you need to do.

[Flutter on iPhone](iphone)

---

Next you will install an IDE for Flutter, namely Android Studio.
Don't let the name fool you, as it is great for Flutter development no matter the platform.

# [Continue](android-studio)
