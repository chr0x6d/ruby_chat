#!/usr/bin/env ruby
require "socket"

class Client
  def get_input(prompt = '> ')
    print prompt
    msg = $stdin.gets.chomp
  end

  def initialize(host, port)
    @client = TCPSocket.new(host, port)
    puts "Enter your username"
    @nickname = get_input
    # First communication from client is sending their chosen nickname
    @client.puts @nickname
    listen
    send
    @listen_thread.join
  end

  def listen
    @listen_thread = Thread.new() do
      loop do
        msg = @client.gets.chomp
        puts msg
      end
    end
  end

  def send
    loop do
      msg = get_input("#{@nickname}> ")
      @client.puts msg
    end
  end
end
HOST = ARGV[0]
PORT = ARGV[1]
HOST ||= 'localhost'
PORT ||= 3000
Client.new(HOST, PORT)
