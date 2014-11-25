  TOR_RUBY  [![Code Climate](https://codeclimate.com/github/bennacer860/tor_ruby/badges/gpa.svg)](https://codeclimate.com/github/bennacer860/tor_ruby)

This script is a working example of how ruby can interact with Tor. It uses mechanize to grap the current ipaddress (from
ifconfig.org/ip) and then signal new ip address to tor (using tor-control-protocol). Finally check if the ip adress has
changed and display the result.

