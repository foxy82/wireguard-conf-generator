# Generate NordVPN Config

## Setup

First run the setup script to ensure everything is installed. Technicaly the script doesn't require 

```bash
./nordvpn/setup.sh
```

Then get an access token by going to [https://my.nordaccount.com/dashboard/nordvpn/access-tokens/authorize/](https://my.nordaccount.com/dashboard/nordvpn/access-tokens/authorize/)

You can add this into the environment or the file.

To add to the environment:

```bash
export NORDVPN_ACCESS_TOKEN="Your access token"
```

To make it available on every login you can either add the token to the `create_nordvpn_config.sh` file 

```bash
# Either set NORDVPN_ACCESS_TOKEN in your environment or paste it in here
if [ -z "${NORDVPN_ACCESS_TOKEN}" ]; then
  NORDVPN_ACCESS_TOKEN="your_actual_token_here"
fi
```

or add it to the end of your `~/.profile` file

```bash
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export NORDVPN_ACCESS_TOKEN="Your access token"
```

## Creating config

To create a config file for your recommended local server run:

```bash
./nordvpn/create_nordvpn_config.sh
```

You can also specify a 2 letter code to find the recommened server for a different country. 
E.g. to find a german server.

```bash
./nordvpn/create_nordvpn_config.sh DE
```

You will get a file created named like: `es1234.nordvpn.com-wireguard.conf`

This can then be used where [split-vpn](https://github.com/peacey/split-vpn) refers to a config file called `wg0.conf`


## Thanks

This repo is basically just combining the knowledge in this gist - specfically [https://gist.github.com/bluewalk/7b3db071c488c82c604baf76a42eaad3?permalink_comment_id=4967841#gistcomment-4967841](https://gist.github.com/bluewalk/7b3db071c488c82c604baf76a42eaad3?permalink_comment_id=4967841#gistcomment-4967841)
