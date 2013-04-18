This script is a working example of how ruby can interact with Tor. It uses mechanize to grap the current ipaddress (from
ifconfig.org/ip)and then signal new ip address to tor (using tor-control-protocol),and finally check if the ip adress has
changed and display the result.
