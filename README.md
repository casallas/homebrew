Homebrew Linux Port
===================

*Note*: There is a more official (and more recent) Linux port of Homebrew here: https://github.com/Homebrew/linuxbrew

This is the Linux port of Homebrew.

Initially done by Sergio Rubio, continued by Juan Sebastian Casallas.

Requirements
------------
- git (unless you want to manually download the source tarball: https://github.com/jscasallas/homebrew/zipball/linux)
- ruby 1.9.3
- gcc (should work with old versions)

Installation
------------

I've worked on this port to use it on machines where you don't have sudo access. The following instructions imply 
that you will install in your home directory, to install elsewhere you may add a different path at the end of the 
clone command. I'm also assuming you are using bash. For other shells, change the lines starting with `echo`.

```sh
cd ~
git clone -b linux https://github.com/jscasallas/homebrew.git
echo "# Prepend homebrew bins to your PATH" >> ~/.bashrc
echo "export PATH=~/homebrew/sbin:~/homebrew/bin:~/homebrew/Library/Contributions/examples:$PATH" >> ~/.bashrc
```

If you want bash completion you may also add:
```sh
echo "# Brew bash completion" >> ~/.bashrc
echo "source `brew --prefix`/Library/Contributions/brew_bash_completion.sh" >> ~/.bashrc
echo "if [ -f `brew --prefix`/etc/bash_completion ]; then" >> ~/.bashrc
echo " . `brew --prefix`/etc/bash_completion" >> ~/.bashrc
echo "fi" >> ~/.bashrc
```

Usage
-----

The functionality of this port is pretty limited compared to the upstream homebrew, but the main features,
such as dependency tracking, are there. Maybe one day all features will get implemented.

For example you might want to start installing cmake:
`brew install cmake`

Then check its version:
`brew info cmake`

All the available formulas should be in `/Library/Formula`, feel free to add your own and add make a pull request.

Disclaimer
----------

Use this at your own risk, I don't take any responsability if you wreck anything up. *NEVER* use sudo and you 
*should* be OK.

Initial blog post from Sergio Rubio
-----------------------------------

Sergio's instructions require you to have sudo access and they point to his no longer existing git repo:

http://blog.frameos.org/2010/11/10/mac-homebrew-ported-to-linux/
