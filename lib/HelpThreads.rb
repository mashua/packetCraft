def return_serial_listen_thread( seriaport )
  #Spawn the serial line listener thread.
  #a call to Thread.sleep() is not needed because the
  #loop is blocking on its own, at the Serial.read_whatever() call.
  slt = Thread.new() {      
        $serialPort.read_timeout=0; #read data as soon they appear on the rx line.
        message = Array.new();
        frameseen=0;
        counter=0;
        loop do #keep 'polling' the rx line.
                #here standard IO calls can be used on the $serialPort
  #        incmData = $serialPort.readchar;
          begin
#$mutex_obj.lock();
            incmData = $serialPort.readbyte;
#$mutex_obj.unlock();
#            incmData = $serialPort.getbyte;
#            print("#{incmData} ");
          rescue => ex
            print("\nNO MORE BYTES\n");
          end
#          print incmData.chr; #print incomming data as ASCII char
          if frameseen != 0
            message<<incmData;
            counter=counter+1;
          end
          if incmData == FRAME_DEL_H
            frameseen=frameseen+1;
            counter=counter+1;
            message<<incmData;
            if frameseen == 2 
              counter = counter-1;
              message.pop();
            end
          end
          if frameseen == 2 #&& counter >=0 && message.length <= (counter -1)
              frameseen = 0;
              print("\n\n#{message} queued\n")
#              $serial_line_queue.enq(  message[0,counter] ); #returns a new sub-array, and puts it into queue
               $serial_to_server_q.enq(  message[0,counter] ); #returns a new sub-array, and puts it into queue
              message.clear;
              counter = 0;
          end
          print("#{incmData.chr} ");
        end#loop ends here
    }; 
#    slt.run();
return slt;
end

def return_slice_thread()
  #fire and forget thread, slices.
    sliceThr = Thread.new( ) { 
      loop do
#        $mutex_obj.lock();
          #with 'false' as option, the call blocks until something can be dequeued
          parseMessage( $serial_to_server_q.deq(false) );
#        $mutex_obj.unlock();
      end
  };
  return sliceThr;
#  sliceThr.run();
end

def return_udp_slice_thread()
  #fire and forget thread, slices.
    sliceThr = Thread.new( ) { 
      tempA = Array.new();
      loop do
#        $mutex_obj.lock();
          #with 'false' as option, the call blocks until something can be dequeued
          data = $udp_to_server_q.deq(false);
          data.to_s.each_byte { |elem|
              tempA.push( sprintf("%08b",elem).split(//).map{ |elem| elem.to_i } );
          }
          tempA.flatten!(1);
          printECSS( tempA );    
          tempA.clear;
#          parseMessage( $udp_to_server_q.deq(false) );
#        $mutex_obj.unlock();
      end
  };
  return sliceThr;
#  sliceThr.run();
end

#Thread that transfers a message from the local TCs queue to the serial line
def return_local_queue_to_serial_thread()
  to_serialThr = Thread.new() {
    loop do
      #dequeue a TC yaml, convert it to binary stream, and send it over.
      
#      $server_to_serial_q.deq(false);

    end
  }
  return to_serialThr;
end