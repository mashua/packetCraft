require "socket"

class CCSDSClient

  def initialize( server )
    @server = server;
    @request = nil;
    @response = nil;
    listen();
    send();
    @request.join
    @response.join
  end

  def listen
    @response = Thread.new do
      loop do
        msg = @server.gets;
        puts "#{msg}";
      end
    end
    
  end

  def send
    @request = Thread.new do
      loop do
        msg = $stdin.gets.chomp
        @server.puts( msg )
      end
    end
  
  end
  
end #class end