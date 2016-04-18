require "socket"

class CCSDSTCTMServer
  #tc_port accepts TCs
  #tm_port serves TMs
  def initialize( ip )
    if $cmdlnoptions[:m] != nil 
      @tc_server_p = $cmdlnoptions[:m];
      @tc_server = TCPServer.open( @tc_server_p );
      @l_t = fire_tc_server();
    end
    if $cmdlnoptions[:n] != nil 
      @tm_server_p = $cmdlnoptions[:n]
      @tm_server = TCPServer.open( @tm_server_p );
      @slc_t = fire_tm_server();
    end
  end
  
  #accepts TCs and forwards them to serial line queue
  def fire_tc_server()
      tc_server = Thread.start(){ | client |
        printf("\nTelecommand acceptance server fired up on port: #{@tc_server_p}, awaiting connection...\n");
        client =  @tc_server.accept();
        printf("\nConnection accepted\n");
        #TODO when client disconnects we are looping like crazy probably because IO remains 'open', FIXIT!
        loop do
          tc = client.gets();
          $server_to_serial_q.enq( tc)#client.gets());
        end
      };
            sleep(0.1);
      return tc_server;
  end
  
  #serves TM messages to client(s)s
  def fire_tm_server()
      tm_server = Thread.start(){ | client |
        printf("\Telemetry messaging server fired up on port: #{@tm_server_p}, awaiting connection...\n");
        client = @tm_server.accept();
        printf("\nConnection accepted\n");
        #TODO when clint disconnects we are looping like crazy, FIXIT!
        loop do
#          client.puts("new tm");
          client.puts( $server_to_client_q.deq(false));
        end
      };
            sleep(0.1);
      return tm_server;
  end
end #class end

