
Using the CLI

Once you’ve installed WARP, you can begin using the CLI with a single command:

warp-cli --help

The CLI will display the output below.

~$ warp-cli --help

WARP 0.2.0

Cloudflare

CLI to the WARP service daemon

USAGE:

warp-cli [FLAGS] [SUBCOMMAND]

FLAGS:

--accept-tos    Accept the Terms of Service agreement

- h, --help          Prints help information
- l                  Stay connected to the daemon and listen for status changes and DNS logs (if enabled)
- V, --version       Prints version information

SUBCOMMANDS:

register                    Registers with the WARP API, will replace any existing registration (must be run

before first connection)

teams-enroll                Enroll with Cloudflare for Teams

delete                      Deletes current registration

rotate-keys                 Generates a new key-pair, keeping the current registration

status                      Asks the daemon to send the current status

warp-stats                  Retrieves the stats for the current WARP connection

settings                    Retrieves the current application settings

connect                     Asks the daemon to start a connection, connection progress should be monitored with

- l

disconnect                  Asks the daemon to stop a connection

enable-always-on            Enables always on mode for the daemon (i.e. reconnect automatically whenever

possible)

disable-always-on           Disables always on mode

disable-wifi                Pauses service on WiFi networks

enable-wifi                 Re-enables service on WiFi networks

disable-ethernet            Pauses service on ethernet networks

enable-ethernet             Re-enables service on ethernet networks

add-trusted-ssid            Adds a trusted WiFi network, for which the daemon will be disabled

del-trusted-ssid            Removes a trusted WiFi network

allow-private-ips           Exclude private IP ranges from tunnel

enable-dns-log              Enables DNS logging, use with the -l option

disable-dns-log             Disables DNS logging

account                     Retrieves the account associated with the current registration

devices                     Retrieves the list of devices associated with the current registration

network                     Retrieves the current network information as collected by the daemon

set-mode

set-families-mode

set-license                 Attaches the current registration to a different account using a license key

set-gateway                 Forces the app to use the specified Gateway ID for DNS queries

clear-gateway               Clear the Gateway ID

set-custom-endpoint         Forces the client to connect to the specified IP:PORT endpoint

clear-custom-endpoint       Remove the custom endpoint setting

add-excluded-route          Adds an excluded IP

remove-excluded-route       Removes an excluded IP

get-excluded-routes         Get the list of excluded routes

add-fallback-domain         Adds a fallback domain

remove-fallback-domain      Removes a fallback domain

get-fallback-domains        Get the list of fallback domains

restore-fallback-domains    Restore the fallback domains

get-device-posture          Get the current device posture

override                    Temporarily override MDM policies that require the client to stay enabled

set-proxy-port              Set the listening port for WARP proxy (127.0.0.1:{port})

help                        Prints this message or the help of the given subcommand(s)

You can begin connecting to Cloudflare’s network with just two commands. The first command, register, will prompt you to authenticate. The second command, connect, will enable the client, creating a WireGuard tunnel from your device to Cloudflare’s network.

~$ warp-cli register

Success

~$ warp-cli connect

Success

Once you’ve connected the client, the best way to verify it is working is to run our trace command:

~$ curl https://www.cloudflare.com/cdn-cgi/trace/

And look for the following output:

warp=on

Want to switch from encrypting all traffic in WARP to just using our 1.1.1.1 DNS resolver? Use the warp-cli set-mode command:

~$ warp-cli help set-mode

warp-cli-set-mode

USAGE:

warp-cli set-mode [mode]

FLAGS:

- h, --help       Prints help information
- V, --version    Prints version information

ARGS:

<mode>     [possible values: warp, doh, warp+doh, dot, warp+dot, proxy]

~$ warp-cli set-mode doh

Success

Protecting yourself against malware with 1.1.1.1 for Families is just as easy, and it can be used with either WARP enabled or in straight DNS mode:

~$ warp-cli set-families-mode --help

warp-cli-set-families-mode

USAGE:

warp-cli set-families-mode [mode]

FLAGS:

- h, --help       Prints help information
- V, --version    Prints version information

ARGS:

<mode>     [possible values: off, malware, full]

~$ warp-cli set-families-mode malware

Success

