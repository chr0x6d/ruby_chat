#!/usr/bin/ruby
require "socket"

class Server
  def initialize(host, port)
    @server = TCPServer.open(host, port)
    @clients = {}
    run
  end

  def run
    loop do
      Thread.new(@server.accept) do |client|
        client.puts "Enter your username"
        nickname = client.gets.chomp
        @clients.each_key do |other_nick|
          if nickname == other_nick
            client.puts "That username is already taken"
            Thread.kill self
          end
        end
        @clients[nickname] = client
        broadcast("#{nickname} has joined the server!")
        listener(nickname, client)
      end
    end
  end

  def broadcast(msg)
    puts msg
    @clients.each_value do |client|
      client.puts(msg)
    end
  end

  def listener(nickname, client)
    loop do
      msg = client.gets
      puts("(#{client}) #{nickname}> #{msg}")
      @clients.each_value do |other_client|
        unless other_client == client
          other_client.puts("#{nickname}> #{msg}")
        end
      end
    end
  end
end

Server.new("localhost", 3000)
