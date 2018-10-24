require "libtelnet"
require "socket"

module Libtelnet
  VERSION = "0.1.0"
end

event_handler = ->(telnet : LibTelnet::Telnet*, event : LibTelnet::TelnetEvent*, user_data : LibTelnet::UserData*) do
  puts "Handling an event of type #{event.value.type}"
  case event.value.type
    when LibTelnet::EventType::TELNET_EV_DATA
      data = event.value.data

      puts "As string: #{String.new(data.buffer)}"
      puts "As bytes: #{String.new(data.buffer, data.size).bytes}"
    when LibTelnet::EventType::TELNET_EV_SEND
      data = event.value.data

      puts "As string: #{String.new(data.buffer)}"
      puts "As bytes: #{String.new(data.buffer, data.size).bytes}"
  end
end

options = [] of LibTelnet::TelOpt

telnet = LibTelnet.telnet_init(options, event_handler, 0, nil)

server = TCPServer.new("0.0.0.0", 4242)
loop do
  socket = server.accept?
  if socket
    slice = Bytes.new(1024)

    spawn do
      loop do
        bytes = socket.as(Socket).read slice
        LibTelnet.telnet_recv telnet, slice, bytes, nil
      end   
    end
  end
end

#LibTelnet.telnet_printf(telnet, "%s\r\n", "printf test")
#LibTelnet.telnet_free telnet
