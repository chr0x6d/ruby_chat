#!/usr/bin/ruby
require "socket"

class Client
  def initialize(host, port)
    @client = TCPSocket.new(host, port)
    listen
    send
    @listen_thread.join
    @send_thread.join
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
    @send_thread = Thread.new() do
      loop do
        msg = $stdin.gets.chomp
        @client.puts msg
      end
    end
  end
end

Client.new("localhost", 3000)
