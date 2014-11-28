Teensy 3.1 Raw Build Environment
================================

This is a raw teensy 3.1 build environment, based on Teensyduino 1.20. 
There are already several of these around, but usually eschew windows support and/or do not build a core library causing unnecessarily large firmware images.

Windows is currently supported, other OSes pending the effort and time required.

Usage
-----
- `make` will compile the current project, rebuilding the required files and producing both an .elf and a .hex file.
- `make upload` will open the launcher and attempt to upload the .hex file onto a connected teensy.
- `make clean` will remove all the build output and intermediate files.

Sources
-------
- The `teensy3` and `tools` directories are taken from [Teensyduino](http://www.pjrc.com/teensy/td_download.html)
- The `Makefile` is the copied from `teensy3/Makefile` and modified to fit.

Credits
-------
- [PJRC](https://www.pjrc.com/) for the awesome teensy, open-sourcing the core libraries, and generally encouraging people.
- [apmorton](https://github.com/apmorton/teensy-template) for his Makefile that provided some refinements to my original effort.

 