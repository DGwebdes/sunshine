# Initial Linux Setup and Config

- **Needs sudo privileges**
- **Needs git installed for now.**
- **This is not fully automated and needs user input at some points**

## But why ?

I often use Virtual Machines for my work, personal labs, breaking stuff and what not.
But there are some tools and configurations I like to have across all of them.
Having to configure everything everytime I spin a new machine can be an annoyance to say the least.
The solution? A script of course.

## What it Installs

- [x] Curl, wget (Just in case)
- [x] Build-Essential (and distros equivalent, e.g. gcc-c++, readline-devel, and so on)
- [x] Lua & LuaRocks
- [x] Neovim text editor
- [x] Neovim Kickstart (solid nvim configuration)
- [x] Oh-My-Zsh (sets zsh as the default shell)

## Where it Works

- [x] Debian / Ubuntu
- [x] Fedora
- [x] RHEL
- [x] Centos
- [x] Arch
- [x] OpenSUSE

## Clone it and Run it

```
git clone https://github.com/DGwebdes/sunshine.git
```
```
sunshine/sunshine.sh
```

That's it.
