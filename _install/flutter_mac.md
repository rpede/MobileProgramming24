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

## iPhone

If you have an iPhone and would like to be able to build your Flutter projects
for it, then there is a bit of extra setup you need to do.

If you don't have an iPhone then skip to [here](./android_studio.md).

To build for iPhone you will need Xcode which can be found in App Store.
So go ahead and install it!

To make plugins work for iPhone you need to have
[CocoaPods](https://cocoapods.org/) installed.
But before you can install it you will need a couple of other things.

Install [Homebrew](https://brew.sh/) if you don't have it already.
If you are unsure, you can check by entering `brew` in Terminal.

```sh
# To install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

You can use brew to install Ruby which is required by CocoaPods.

```sh
brew install ruby
```

Then add a couple of more environment variables to `.zshrc`.

```sh
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
```

Finally install CocoaPods with:

```
brew install cocoapods
brew link cocoapods
```

Hopefully you should see a checkmark for cocoapods now when running `flutter doctor` .

If you see "Unable to get list of installed Simulator runtimes." it can be fixed
by running `xcodebuild -downloadPlatform iOS` as shown in the screenshot.

![Fix missing Simulator runtimes](../mac_missing_simulator_runtime.png)

Next you will install an IDE for Flutter, namely Android Studio.
Don't let the name fool you, as it is great for Flutter development no matter the platform.

# [Continue](android-studio)
