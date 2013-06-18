#!/usr/bin/env ruby
require 'socksify'
require 'mechanize'
require 'net/telnet'

class Tor
  #debug
  #Socksify::debug = true

  def initialize(control_port='9051',socks_port='9050')
    @tor_control_port = control_port
    @tor_socks_port   = socks_port
    TCPSocket::socks_server = "127.0.0.1"
    TCPSocket::socks_port = @tor_socks_port
  end

  def get_current_ip_address
    # rubyforge_www = TCPSocket.new("rubyforge.org", 80)
    a = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac FireFox'
    end
    a.get('http://ifconfig.me/ip').body.chomp
  rescue Exception => ex
    puts "error getting ip: #{ex.to_s}"
    return ""
  end

  def get_new_ip
    puts "get new ip address"
    old_ip_address = get_current_ip_address
    tor_switch_endpoint
    sleep 10 # wait for connection
    new_ip_address = get_current_ip_address
    if (old_ip_address != new_ip_address) # Compare your old ip with your current one
      puts "ip changed from  #{old_ip_address} to #{new_ip_address}"
      return true
    else
      puts "ip same #{old_ip_address}"
      return false
    end
  end

  def tor_switch_endpoint
    puts "tor_switch_endpoint.."
    localhost = Net::Telnet::new("Host" => "localhost", "Port" => "#{@tor_control_port}", "Timeout" => 10, "Prompt" => /250 OK\n/)
    localhost.cmd('AUTHENTICATE ""') { |c| print c; throw "Cannot authenticate to Tor" if c != "250 OK\n" }
    localhost.cmd('signal NEWNYM') { |c| print c; throw "Cannot switch Tor to new route" if c != "250 OK\n" }
    localhost.close
  end

  #block to be executed though the proxy
  def proxy_mechanize
    yield
  end
end

#start tor first 
#tor --controlport 9051
t=Tor.new
t.proxy_mecahnize { 
  a = Mechanize.new
  puts a.get('http://ifconfig.me/ip').body.chomp
}
