#!/usr/bin/env ruby
require 'socksify'
require 'mechanize'
require 'net/telnet'


tor_control_port = '9051'
tor_socks_port   = '9050'
#debug
#Socksify::debug = true

def get_current_ip_address(socks_port)
  TCPSocket::socks_server = "127.0.0.1"
  TCPSocket::socks_port = socks_port
  # rubyforge_www = TCPSocket.new("rubyforge.org", 80)
  a = Mechanize.new do |agent|
    agent.user_agent_alias = 'Mac FireFox'
  end
  a.get('http://ifconfig.me/ip').body.chomp
rescue Exception => ex
  puts "error getting ip: #{ex.to_s}"
  return ""
end

def get_new_ip(control_port, socks_port)
  puts "get new ip address"
  old_ip_address = get_current_ip_address(socks_port)
  tor_switch_endpoint(control_port)
  sleep 10 # wait for connection
  new_ip_address = get_current_ip_address(socks_port)
  
  if (old_ip_address != new_ip_address) # Compare your old ip with your current one
    puts "ip changed from  #{old_ip_address} to #{new_ip_address}"
    return true
  else
    puts "ip same #{old_ip_address}"
    return false
  end
end

def tor_switch_endpoint(control_port)
  localhost = Net::Telnet::new("Host" => "localhost", "Port" => "#{control_port}", "Timeout" => 10, "Prompt" => /250 OK\n/)
  localhost.cmd('AUTHENTICATE ""') { |c| print c; throw "Cannot authenticate to Tor" if c != "250 OK\n" }
  localhost.cmd('signal NEWNYM') { |c| print c; throw "Cannot switch Tor to new route" if c != "250 OK\n" }
  localhost.close
end




#start tor first 
#tor --controlport 9051

5.times do
  get_new_ip(tor_control_port, tor_socks_port)
end