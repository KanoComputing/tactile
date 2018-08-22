# Tactile

Provides a graphical walkthrough into the Kano Kit Onboarding.
The outcome of the application is the creation of a new Kano User on the kit.

## Development Environment

Below are instructions on how to prepare your environment to build and test the Overture app.

### Raspberry Pi

You can build Overture on the Raspberry Pi using the Kano OS system.
Install the librarires with `apt-get install libqt5all-dev build-essential`,
then add `/usr/local/qt5/bin` to your PATH environment variable.

### Mac OS

Download and install QT 5.7 or higher for Mac OS, from the official site: https://www.qt.io/qt5-7
Choose open source distribution. There is no need to select the QT Creator during the installation.

Edit your `~/.bash_profile` script, and add the path to the QT5 binaries, example `export PATH=$PATH:~/Qt57/5.7/clang_64/bin`.
You should be able to call `qmake` from a terminal shell.

## Building

Perform the following steps to build Overture.

```
$ git clone https://github.com/KanoComputing/kano-qt-sdk
$ git clone https://github.com/KanoComputing/overture.git
$ cd overture/overture
$ qmake
$ make
```

On the Raspberry Pi, you can build the debian package too:

```
$ sudo apt-get install devscripts
$ cd overture/overture
$ debuild -us -uc -b
```

## Running the app

On the Raspberry Pi, run the app found as `./bin/overture`. It will occupy the complete screen.

On Mac OS, the app will be at `./bin/overture.app/Contents/MacOS/overture`.
It should be centered on your screen, above all other apps. There is no close button,
you can quit the app at any time from the Docker.

On Mac OS, the system calls that relate to creating a new user and starting the graphical environment, are disabled.

## Running the tests

To compile and run the test suite (and the main app as a by-product), run
```
$ qmake -r CONFIG+=tests
$ make
$ make check
```

## Workflow development

The workflow of the application is governed by the QML Javascript file located at `res/ui/Overture/flow.js`.
Editing this file does not need a recompilation, simply restart the Overture app.

The `create_steps` function collects all the screens in sequential order, this is the main function to work on.

Each call to `new_scene` resets and clears the Overture Terminal, and then jumps into a new screen.

Each of the `new_step` calls represent either a message to go into the terminal, with `scene.echo_msg`,
or a prompt requested to the user, with `scene.prompt`, the response typed by the user is returned into the `msg` variable.

Starting an application from the Overture is accomplished with the `launcher.start_app` method, specifying command line
and username. When username is null it will be run as the superuser on the RPi. The overture app will fade away
while the app is running. On Mac OS, a popup message will be sent to Finder to mimic the application flow.

Simple logs can be added with Javascript `console.log` calls.
