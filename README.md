Teensy 3.1 Raw Build Environment
================================

This is a raw teensy 3.1 build environment, based on Teensyduino 1.20.

There are already several of these around, but usually eschew windows support and/or do not build a core library causing unnecessarily large firmware images.

Linux (x86_64) and Windows are currently supported, other (Unixy) OSes should work with the correct tools and slight modifications to `Makefile`.

Usage
-----

Put your C/C++ sources in `src`. Makefile compiles C files using C99 standard (with GNU extensions) and C++ files using the C++0x standard (also with GNU extensions).

On platforms that require it, copy the `49-teensy.rules` from your platform's tools directory to `/etc/udev/rules.d` before plugging in the teensy.

- `make` will compile the current project, rebuilding the required files and producing both an .elf and a .hex file.
- `make upload` will open the launcher and attempt to upload the .hex file onto a connected teensy.
- `make clean` will remove all the build output and intermediate files.

Sources
-------
- The `teensy3` and `tools` directories are taken from the [Teensyduino](http://www.pjrc.com/teensy/td_download.html) installer.
- The `49-teensy.rules` file for linux installs is taken from the [Teensyduino](http://www.pjrc.com/teensy/td_download.html) web page.
- The `Makefile` is the moved from `teensy3/Makefile` above and modified.

Credits
-------
- [PJRC](https://www.pjrc.com/) for the awesome teensy, open-sourcing the core libraries, and generally encouraging people.
- [apmorton](https://github.com/apmorton/teensy-template) for his Makefile that provided some refinements to my original effort.

 
