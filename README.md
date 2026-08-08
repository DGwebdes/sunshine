# Initial Linux Setup and Config

## But why ?

I often use Virtual Machines for my work, personal labs, learning cyber security and what not
Having to configure everything everytime I spin a new machine can be an annoyance to say the least.
The solution? A script of course.

Most often I have to:

- Update and Upgrade package manager and local db
- Install missing packages 
- Install necessary tools for my specific work
- Install the tools I ALWAYS use regardless

## What it Installs

- [x] Curl, wget (need them)
- [x] Build-Essential (and distros equivalent, e.g. gcc-c++, readline-devel, and so on)
- [x] Neovim text editor
- [x] Neovim Kickstart (solid nvim configuration)
- [x] Oh-My-Zsh (sets zsh as the default shell)
- [ ]AI tools (opencode)
- [ ] Docker Engine

This assumes you have Git and some of the most basic packages installed. 
Right now this also only works with Linux distributions.

## Platforms

- [x] Debian / Ubuntu
- [x] Fedora
- [ ] RHEL
- [ ] Centos
- [ ] Arch
