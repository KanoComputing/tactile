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

```
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

```
containingFolder
   |-- tactile
   |-- kano-qt-sdk
   |-- kano-toolset
```

Compile libparson and symlink its header files:

```
cd ~/Kano/kano-toolset/libs/parson
sudo mkdir -p /usr/local/include/parson
sudo ln -s `pwd`/* /usr/local/include/parson
make
sudo ln -s `pwd`/release/libparson.dylib /usr/local/lib
```

Compile libkano_logging and symlink its header files:

```
cd ~/Kano/kano-qt-sdk
sudo mkdir -p /usr/local/include/kano/kano_logging
sudo ln -s `pwd`/lib/kano_logging/includes/* /usr/local/include/kano/kano_logging
qmake
make
sudo ln -s `pwd`/lib/build/* /usr/local/lib
```

### Linux

ps. This linux README is incomplete (installation issue not solved)

first update your sistem

      sudo apt-get update

- Install [QtCreator 5.11](https://www.lucidar.me/en/dev-c-cpp/how-to-install-qt-creator-on-ubuntu-18-04/) or higher running these commands:

       sudo apt install build-essential

       sudo apt install qtcreator

If you want Qt 5 to be the default Qt version to be used when using development binaries like qmake, install the following package:

- `sudo apt install qt5-default`
- `sudo apt install qt5-doc`
- `sudo apt install qt5-doc-html qtbase5-doc-html`
- `sudo apt install qtbase5-examples`

You dont need to set the PATH, linux will do it for you!

if get the error: *cannot find feature `kano_i18n`*

clone the following
repos and have the following structure:

```git
containingFolder
   |-- tactile
   |-- kano-qt-sdk
   |-- kano-toolset
```

commands:

`mkdir containingFolder`

`mv tactile/ containingFolder/`

Clone inside containingFolder the repo [kano-qt-sdk](https://github.com/KanoComputing/kano-qt-sdk) and the repo [kano-toolset](https://github.com/KanoComputing/kano-toolset)

```git
Compile libparson and symlink its header files:

cd ~/Kano/kano-toolset/libs/parson
sudo mkdir -p /usr/local/include/parson
sudo ln -s `pwd`/* /usr/local/include/parson
make

```

in mac we have `libparson.dylib` that in linux is called `libparson.so`
so replace them.

so run ```sudo ln -s `pwd`/release/libparson.so /usr/local/lib```

```git
Compile libkano_logging and symlink its header files:

cd ~/Kano/kano-qt-sdk
sudo mkdir -p /usr/local/include/kano/kano_logging
sudo ln -s `pwd`/lib/kano_logging/includes/* /usr/local/include/kano/kano_logging
qmake
make
sudo ln -s `pwd`/lib/build/* /usr/local/lib
```

if you get an error on `make` command
`Project ERROR: Unknown module(s) in QT: qml quick`

You need to install **qml&** and **quick**

run `sudo apt-get install qtdeclarative5-dev`

ps. you could find `parson.h` in => cd /usr/local/include/parson/lib

if you run in this error `fatal error: parson/parson.h: No such file or directory` is because user/local/include in not in the path

You could do momentarily a local fix

```git
cd kano-qt-sdk

open => features/kano_build_options.prf

```

modify the file

```git
-macx {
-    LIBS += -L/usr/lib -L/usr/local/lib
-    INCLUDEPATH += /usr/include /usr/local/include
-}
+
+LIBS += -L/usr/lib -L/usr/local/lib
+INCLUDEPATH += /usr/include /usr/local/include
+

```

- run `qmake`

## Building

After setting up the environment on your platform of choice, you should be able
to build the project in the same way as in the debian/rules file.

### Raspberry Pi

Straightforwardly, compiling Tactile now is just:

```
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
