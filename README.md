# Tactile

Explains how touchscreens work through an interactive experience and simple
animations.

## Environment Setup

Below are instructions on how to prepare your environment to build and test
the Tactile app.

### Raspberry Pi

You can build Tactile on the Raspberry Pi using the Kano OS system.
First, make sure you're pointing to the development archive and suite:

`sudo kano-dev staging apt`

Install the Build-Depends as listed in debian/control file:

`sudo apt-get install -y build-essential kano-graphics-libs kano-qt-sdk-dev libqt5all-dev`

Add Qt5 build tools to your PATH:

```bash
echo 'export PATH=$PATH:/usr/local/qt5/bin' >> $HOME/.bashrc
source $HOME/.bashrc
```

### Mac OS

Install Qt 5.11 or higher using brew. I've not tested installing through other
channels so your mileage my vary.

`brew install qt5`

Edit your `~/.bash_profile` script and add the path to the Qt5 binaries, e.g.

`export PATH=/usr/local/Cellar/qt5/5.11.1/bin:$PATH`

You should be able to call `qmake` from a terminal shell.
Next, comes the fun part - compiling all other dependencies. Clone the following
repos and have the following structure:

```bash
containingFolder
   |-- tactile
   |-- kano-qt-sdk
   |-- kano-toolset
```

Compile libparson and symlink its header files:

```bash
cd ~/Kano/kano-toolset/libs/parson
sudo mkdir -p /usr/local/include/parson
sudo ln -s `pwd`/* /usr/local/include/parson
make
sudo ln -s `pwd`/release/libparson.dylib /usr/local/lib
```

Compile libkano_logging and symlink its header files:

```bash
cd ~/Kano/kano-qt-sdk
sudo mkdir -p /usr/local/include/kano/kano_logging
sudo ln -s `pwd`/lib/kano_logging/includes/* /usr/local/include/kano/kano_logging
qmake
make
sudo ln -s `pwd`/lib/build/* /usr/local/lib
```

### Linux

NB This linux README is incomplete (installation issue not solved)

First update your sistem

      sudo apt-get update

- Install [QtCreator 5.11](https://www.lucidar.me/en/dev-c-cpp/how-to-install-qt-creator-on-ubuntu-18-04/) or higher running these commands:

```bash
   sudo apt install build-essential

   sudo apt install qtcreator
```

If you want Qt 5 to be the default Qt version to be used when using development binaries like qmake, install the following package:

```bash
sudo apt install qt5-default
sudo apt install qt5-doc
sudo apt install qt5-doc-html qtbase5-doc-html
sudo apt install qtbase5-examples
```

You dont need to set the PATH, linux will do it for you!

If get the error: *cannot find feature `kano_i18n`*

clone the following repository and have the following structure:

```bash
containingFolder
   |-- tactile
   |-- kano-qt-sdk
   |-- kano-toolset

```

commands:

```bash
mkdir containingFolder

mv tactile/ containingFolder/

```

Clone inside containingFolder the repo [kano-qt-sdk](https://github.com/KanoComputing/kano-qt-sdk) and the repo [kano-toolset](https://github.com/KanoComputing/kano-toolset)

```bash
Compile libparson and symlink its header files:

cd ~/Kano/kano-toolset/libs/parson
sudo mkdir -p /usr/local/include/parson
sudo ln -s `pwd`/* /usr/local/include/parson
make

```

In mac we have `libparson.dylib` that in linux is called `libparson.so`. You have to replace them.

```bash
sudo ln -s `pwd`/release/libparson.so /usr/local/lib
```

Compile libkano_logging and symlink its header files:

```bash
cd ~/Kano/kano-qt-sdk
sudo mkdir -p /usr/local/include/kano/kano_logging
sudo ln -s `pwd`/lib/kano_logging/includes/* /usr/local/include/kano/kano_logging
qmake
make
sudo ln -s `pwd`/lib/build/* /usr/local/lib
```

If you get an error on `make` command

```bash
Project ERROR: Unknown module(s) in QT: qml quick
```

You need to install **qml&** and **quick**

```bash
sudo apt-get install qtdeclarative5-dev
```

NB You could find `parson.h` in => `/usr/local/include/parson/lib`

If you run in this error `fatal error: parson/parson.h: No such file or directory` is because `user/local/include` in not in the path

You could do momentarily a local fix

```bash
cd kano-qt-sdk

open => features/kano_build_options.prf

```

And modify the file

```bash
-macx {
-    LIBS += -L/usr/lib -L/usr/local/lib
-    INCLUDEPATH += /usr/include /usr/local/include
-}
+
+LIBS += -L/usr/lib -L/usr/local/lib
+INCLUDEPATH += /usr/include /usr/local/include
+

```

Eventually you should run:

```bash
run qmake
```

## Alternative way for linux to pass files to the Kano-kit

Enter in kano-kit server and copy the path that you need

1. You can find the path with  the command: `dpkg-query -L <package name>` => Example: `dpkg-query -L tactile`

NOTE: `dpkg-query -L <package name> | grep <name of the file>`

NB This method won't work for a new file, use the install.file instead

2. You can find the path using the install file in the debian folder
NB You must complete manually the path

```bash
tactile
   |-- bin
   |-- build
   |-- debian
       |--tactile.install

```

Example `res/ui` is inside the kano-kit => `/usr/share/tactile`

Example path `/usr/share/tactile/`

Use this command to login inside the kano-kit's server

Syntax `ssh user@ip` => Example: `ssh laura@172.16.254.180`

**NB** You can find your kano-kit ip in the wifi's icon in the kano-kit itself

Now you can syncronize your local file with the kano kit file

**NB** You must exit the kano-kit server and use **root** as **user** run before to run this command

`rsync -avi <path/where I am going copy from> root@172.16.254.180:/path/Where I going copy to/` => `rsync -av ui root@172.16.254.180:/usr/share/tactile/`

NOTE: `-n` it's gonna tell you the output without running the command for async

#### Faster approach

This command is just going to print the output

`rsync -avinr res/ui/*  root@172.16.254.180:/usr/share/tactile/ui/`

See if it's ok then run the same command without the -n flag

`rsync -avir res/ui/*  root@172.16.254.180:/usr/share/tactile/ui/`

If you see multiple file being update on your terminal:

```bash
<f+++++++++ Tactile/Wires/touch_a_grid.qml
<f+++++++++ Tactile/Wires/touch_a_wire.qml
<f+++++++++ Tactile/Wires/touch_indicator.qml
<f+++++++++ Tactile/Wires/touch_points.qml
<f+++++++++ Tactile/Wires/touchscreen.png
<f+++++++++ Tactile/Wires/wire.png
```

If you change the file you need to update the debian/changelog file

Example:

If current version tactile (4.2.0-0)

changelog => tactile (4.3.0-0)

```bash

tactile (4.3.0-0) unstable; urgency=low

  * Change default text formatting to normal

 -- Team Kano <dev@kano.me>  Tue, 12 Mar 2019 15:35:00 +0000

tactile (4.2.0-0) unstable; urgency=low

  * Fixed minor spelling errors
 ...

```

 If in the changelog file there are already changes with the next version you should just update it.

**You may be doing something wrong!**

## Building

After setting up the environment on your platform of choice, you should be able
to build the project in the same way as in the debian/rules file.

### Raspberry Pi

Straightforwardly, compiling Tactile now is just:

```bash
qmake && make -j `nproc`
```

The binary will then be at:

`bin/tactile`

### Mac OS

Similarly, compiling should just be:

`qmake && make -j 4`

The binary will be at:

`bin/tactile.app/Contents/MacOS/tactile`

## Workflow Tips

A few tips specific to working with this project.

### Debugging Messages

You'll want to build using a `make debug` variant rather than running the
release version. Moreover, the debug messages will by default go to the
syslog, so you'll need to disable:

`DEFINES += QT_NO_DEBUG` in `tactile.pro`

`Logger::install_syslog();` in `src/app.cpp`

Make sure you don't forget to switch those back on when making a PR to master.

### Adding New QML Scenes

Create a new folder for your module in `res/ui/Tactile`. Also, add the relevant
scene specification to the `res/ui/scenes.js` file in order to use them further
in `res/ui/flow.js`.
