# packetCraft.
#
# Copyright (C) 2016 by Apostolos D. Masiakos (amasiakos@gmail.com)
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#  *  Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#
#  *  Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

FRAME_DEL_H = 0x7E
FRAME_DEL_B = 0b01111110
FRAME_DEL_B_A = Array.[](0,1,1,1,1,1,1,0)
FRAME_ESCAPE_H = 0x7D
FRAME_ESCAPE_B = 0b01111101
FRAME_ESCAPE_B_A = Array.[](0,1,1,1,1,1,0,1)
$serialPort

def ClaimSerialPort( serialline )
  begin
    $serialPort = SerialPort.new(serialline, 9600, 8, 1, SerialPort::NONE);
#    $serialPort = SerialPort.new(serialline, 4800, 8, 1, SerialPort::NONE);
    #Spawn the serial line listener thread.
    #a call to Thread.sleep() is not needed because the
    #loop is blocking at its own, on the Serial.read_whatever() call.
    x = Thread.new() {      
#      $serialPort2 = SerialPort.new(serialline, 9600, 8, 1, SerialPort::NONE);
      $serialPort.read_timeout=0; #read data as soon they appear on the rx line.
      message = Array.new();
      frameseen=0;
      loop do #keep polling the rx line.
#        printf("\nbefore\n");
#        incmData = $serialPort.read(19);
#        incmData = $serialPort.readchar;
#        incmData = $serialPort.readchar;
         incmData = $serialPort.readbyte;
         
#        print incmData;
        if frameseen >= 1
          message << incmData;
        end
        if incmData == FRAME_DEL_H
          frameseen+=1;
          if frameseen==2
            #end frame has come, parse the message array.
            #reset for the other round.
            frameseen=0;
            print message;
            print("\n");
            begin
#              printf("\n incoming:#{message}");
              parseMessage( Array.new( message));
              message.clear
            rescue=> exe
              raise;
            end
            
          end
        end
#          print incmData.to_s();
#          print("\n");
        
#        printf("\nthe read data are:#{incmData.unpack("C*")}\n");
#        if incmData.unpack("C*").eql?(FRAME_DEL_B_A);
##          printf("\nDISCARING FRAME\n");
#          frameseen+=1;
##        elsif incmData.unpack("C*").eql?(FRAME_ESCAPE_B_A);
#        else
#          if frameseen==2
##            printf("\n\nThe received message is#{ byteDestuff( Array.new(dataA))}\n\n");
#            dataA.clear;
#            frameseen=0;
#          else
#            incmData.unpack("C*").each{ |elem|
#              dataA.push(elem);
##              printf("\ndata in dataArray are:#{data.inspect}")
#            }
#          end
        end
##        $serialPort.flush_input();
##        $serialPort.flush_output();
##        printf("\n#{incmData}\n");
#      end
#      $serialPort2 = Serial.new
#      while true
#        puts "func1 at: #{Time.now}"
#        sleep(1);
#      end
    }; x.run;
  rescue
    $serialPort= nil;
    print("\nWARNING! Serial port (or at least something emulating it) is not availiable on this system,"\
          "continuing without serial transmition/reception support.\n");
  end
end

# Parses an array containing (hopefully) a ECSS-E-70-41A
# message.
def parseMessage(theArray)
    message = Array.new();
    theArray.each { |elem| #elem is Fixnum 
      if elem == FRAME_DEL_H
        next #AKA, waste cycles
      else 
        message.push( sprintf("%08b",elem).split(//).map{ |elem| elem.to_i } );
      end
    }
    message.flatten!(1);
    breakECSS(message);
#    print message.length;
#    print("\n");
#    message.each { |innerArray|
#      print innerArray
#      innerArray.flat
#      messageBits.push(innerArray.to_s(2).split(//).map{|bit| bit.to_i});
#    }
    
#  the.split(//).map{|elem| elem.to_i}
#print messageBits;
#    print("\n#{messageBits.length}");
#  print theArray[0].class
#  print theArray.split(',').map { |elem| elem.to_i  }

#  print("\n");
#print("\n#{the.length}"); 
end

def breakECSS(theArray)
  
  version_number = makeByte( theArray[0,3]);
  type = makeByte( theArray[3,1]);
  data_field_header_flag = makeByte( theArray[4,1]);
  application_process_id = makeByte( theArray[5,11]);
  sequence_flags = makeByte( theArray[16,2]);
  sequence_count = makeByte( theArray[18,14]);
  packet_length = makeByte( theArray[32,16]); #+1 octet
  ccsds_secondary_header_flag = makeByte( theArray[48,1]);
  tc_packet_pus_version_number = makeByte( theArray[49,3]);
  ack = makeByte( theArray[52,4]);
  service_type = makeByte( theArray[56,8]);
  service_subtype = makeByte( theArray[64,8]);
  source_id = makeByte( theArray[72,8]);
  
  packet_length += 1; #plus 1 octet
  packet_length *= 8; #bits number
  packet_length -= 16+32 #remove data field header, crc bits
#  application_data = theArray[80,packet_length*8];
  application_data = bitsToBytes( theArray[80,packet_length]);
#  application_data = bitsToBytes( theArray[80, theArray.length - 15]);
  checksum = CRC8(theArray, theArray.length-16, theArray.length);
  
  print("\n\n");
  print sprintf("|--APID--|--SeqFlags--|--SeqCount--|--Ack--|--SerType--|--SubSerType--|--SourceID--|--ApData--|\n");
  print sprintf("|%01$8s|%02$12s|%03$12s|%04$7s|%05$11s|%06$14s|%07$12s|%08$10s|\n",
    application_process_id.to_s.center(8), sequence_flags.to_s.center(8), sequence_count.to_s.center(8), ack.to_s.center(7), 
    service_type.to_s.center(11), service_subtype.to_s.center(14), source_id.to_s.center(12), application_data.to_s.center(10));
  print sprintf("|--------|------------|------------|-------|-----------|--------------|------------|\n");
  
end

#Returns a two-dimensional array
def CreatePacketSegment( width, height )
  theArray = Array.new( width );
  theArray.map! { Array.new(height)  }
  #return theArray;
end

def SaveTelecmdPacketFile(dir="./packets/packet.yml")
  File.open(dir, "w") do |file|
    file.write $telecmdpackets.to_yaml
  end
end

#Returns the file a String
def SLoadTelecmdPacketFFile(dir="./packets/packet.yml")
  File.read(dir);
end

#Returns the file a YAML
def YLoadTelecmdPacketFFile(dir="./packets/packet.yml");
  YAML::load_file(dir);
end

def ParseMainInput(input)
  if input.to_i == 1
#    print("\n1");
    _implCommand1();
  elsif input.to_i ==2  
#    print("\n2");
    _implCommand2();
  elsif input.to_i ==3  
#    print("\n3");
    _implCommand3();
  elsif input.to_i ==4
#    print("\n4");
    _implCommand4();
  elsif input.to_i ==5
#    print("\n4");
    _implCommand5();
  elsif input == "\n"
    print("\nType a supported command\n");
    PrintBasicMenu();
  else
    printf("\nTerminated (0)\n");
    exit(0);
  end
end

def ParseInnerArrayInput( input, array )
  if input == "\n"
    print array;
  else
    print array[(input.to_i)-1];
  end
end

def PrintRawBin( input, array )
  begin
    if input == "\n"
      array.each{ |elem|
        print elem.pack("C*");
      }
    else
      print array[(input.to_i)-1].pack("C*");
    end
  rescue
    printf("\nNon-existant packet\n");
  end
end

#input, holds the number of packet to tx.
#array, holds the array of packet messages.
#line, holds the Serial line to use for tx-ition
#bytestuff, true for byte stuffing before tx-ition, false else.
def SerialTxRawBin( input, array, line, bytestuff )
  stuffed_array = Array.new();
  i=0;
  if line == nil
    printf("\nNo serial port found, cannot transmit data.\n");
    return;
  end
  if input == "\n"
    if bytestuff==TRUE #tx all packets, bytestuff on
      array.each{ |elem|
        stuffed_array = byteStuff(Array.new(elem));
        i+=stuffed_array.length;
        $serialPort.write(bitsToBytes(stuffed_array).pack("C*") );
        sleep(1.5);
      }
      printf("\nTransmission of #{i} bits, (#{i/8} bytes) completed\n");
    elsif    #tx all packets, bytestuff off
      array.each{ |elem|
        i+=elem.length;
        $serialPort.write( bitsToBytes(elem).pack("C*") );
        sleep(1.5);
      }
      printf("\nTransmission of #{i} bits, (#{i/8} bytes) completed\n");
    end
  else 
    begin  
      if bytestuff==TRUE #tx a specific packet, bytestuff on
        stuffed_array = byteStuff(Array.new(array[(input.to_i)-1]));
        i+=stuffed_array.length;
          printArrayBitsOnBytesSeg(stuffed_array);
        $serialPort.write(bitsToBytes(stuffed_array).pack("C*")); 
        printf("\nTransmission of #{i} bits, (#{i/8} bytes) completed\n");
      else #tx a specific packet, bytestuff off
        txarray = array[(input.to_i)-1];
        i+=txarray.length;
        $serialPort.write(bitsToBytes(txarray).pack("C*"));
        printf("\nTransmission of #{i} bits, (#{i/8} bytes}) completed\n");
      end
    rescue => exception
#      printf("\nnon-existant packet selected\n");
#      puts exception.backtrace
        raise
    end
  end
end

def printArrayBitsOnBytesSeg(theArray)
  fetch = 0;
  while fetch+7 <= theArray.length do
    tempseg2 = theArray[fetch,(8)];
    print sprintf("Byte No:%02d #{tempseg2}\n", (fetch/8).to_i);
    fetch+=8; #go to the start of next byte.
  end
end

#The frame boundary octet is 01111110, (0x7E in hexadecimal notation)
#A "control escape octet", has the bit sequence '01111101', (0x7D hexadecimal).
#If either of these two octet appears in the transmitted data, an escape octet is sent, 
#followed by the original data octet with bit 5 inverted.
#For example, the data sequence "01111110" (0x7E hex)
#would be transmitted as "01111101 01011110" ("0x7D 0x5E" hex)
#Procedure is as: inject into start and end of the array the 0x7E flag.
#Parse the bit array to find patterns of 0x7E or 0x7D in the data.
#If found on the starting position of the data enter: 0x7D (escape octet)
#and the value of 5E, or 5D. The receiving application must detect the espace octet (0x7D),
#discard it, and then on the next received octet to shift (invert) the fifth bit.
def byteStuff( array )
#  printf("\n\nThe initial array is: #{array}, with length:#{array.length}\n\n");
# frame delimeters 0x7E, 0xb01111110, '~'
# escape delimeter 0x7D, 0xb1111101, '}'
#FRAME_DEL_H = 0x7E
#FRAME_DEL_B = 0b01111110
#FRAME_ESCAPE_H = 0x7D
#FRAME_ESCAPE_B = 0b01111101
#  print $indPacketsBinArray[0];
#    printf("\n\n");
#  array = $indPacketsBinArray[0];
#  printf("\n Initial array is:\n #{array}, and length is: #{array.length}\n");
  fetch = 0;
#  iniarraylen = array.length; #keep the initial array length, because it might change
#  print("\n current array length is:#{array.length}\n")
#  for times in 1..(array.length/8)

while fetch+7 <= array.length do 
#     print("\n current array length is:#{array.length}\n")
#    printf("Fetch time #{times}, and fetch is from: #{fetch} to #{fetch+7} \n")
#    tempseg = array.values_at( fetch..(times*8)-1 );
    tempseg = array.values_at( fetch..((fetch+8)-1) );
#    printf("\n");
#    print tempseg; 0b 01111110 010 01111101 01111110 010 01111101 01111110 010 01111101
#    printf("\n\n");
    if tempseg.eql?(FRAME_DEL_B_A)
#      printf("\nFrame delimeter found in data, at offset #{fetch}\n");      
      #add an escape 0x7D and the data which are in the tempseg, with 5thbit inverted
      array[fetch,0] = FRAME_ESCAPE_B_A; #append the escape bit sequence (call with length 0)      
      array[fetch+8,8] = [0,1,0,1,1,1,1,0]; #replace the data found with bit 5 inverted
#      printf("\n #{array.values_at(fetch..fetch+15)} \n");
      fetch+=15;
#      printf("\n\nthe new array is: #{array}\n");
    elsif tempseg.eql?(FRAME_ESCAPE_B_A)
#      printf("\nEscape delimeter found in data, at offset #{fetch}\n");
      #add an escape 0x7D and the data which are in the tempseg, with 5thbit inverted
      array[fetch,0] = FRAME_ESCAPE_B_A; #append the escape bit sequence (call with length 0)      
      array[fetch+8,8] = [0,1,0,1,1,1,0,1]; #replace the data found with bit 5 inverted
#      printf("\n #{array.values_at(fetch..fetch+15)} \n");
      fetch+=15;
#      printf("\n\nthe new array is: #{array}\n");
    end
    fetch+=1;
  end#while ends here
#  print("\nmodified array length is:#{array.length}\n");
#  printf("\nfinal array is:\n");
#  print array;
  array[0,0] = FRAME_DEL_B_A #append the forward array frame.
  array[array.length,0] = FRAME_DEL_B_A #append the end array frame.
#  printf("\n Stuffed array is:\n #{array}, and length is: #{array.length}\n");
  return array;
end

#the reverse of byte stuffing.
#detect the escape sequences in the data and discard them.
#then shift (invert) the fifth bit of the next octet.
#the given array is already without the header/tail frame delimeters
def byteDestuff( array )  
# frame delimeters 0x7E, 0xb01111110, '~'
# escape delimeter 0x7D, 0xb1111101, '}'
#FRAME_DEL_H = 0x7E
#FRAME_DEL_B = 0b01111110
#FRAME_ESCAPE_H = 0x7D
#FRAME_ESCAPE_B = 0b01111101
  pos = 0;
#  printf("\nArray before destuff is:\n #{array}, with size: #{array.length}\n");
  #delete the header flag
#    array.slice!(0,8);
  #delete the tail flag
#    array.slice!(array.length-8, 8);
#  printf("\nArray after flag destuff is:\n #{array}, with size: #{array.length}\n");
  
while pos+7 <= array.length do
    tempseg = array.values_at( pos..(pos+8)-1 );
    if tempseg.eql?(FRAME_ESCAPE_B_A)
#      printf("\nEscape delimeter found in data, at offset #{pos}\n"); 
#      printf("\nto remove is: #{array.values_at(pos..pos+7)}, and length is: #{array.length}\n");
      #remove the escape 0x7D from the array and invert the fifth bit of the next 8 bits data.
      array.slice!(pos,8) #remove the escape bit sequence      
#      printf("\narray is: #{array.values_at(pos..pos+7)}, and length is: #{array.length} \n");
      array[pos+2] = 1; #replace the data found with bit 5 inverted
#      printf("\narray is: #{array.values_at(pos..pos+7)}, and length is: #{array.length} \n");
#      printf("\n #{array.values_at(fetch..fetch+15)} \n");
      pos+=7;
#      printf("\nthe new array is: #{array}, and length is: #{array.length}\n");
    end
    pos+=1;
  end#while ends here
#   printf("\nfinal array after destuff is: #{array}, and length is: #{array.length}\n");
  return array;
end

# Accepts an array of bits, and returns an array of bytes.
def bitsToBytes(theArray)
  fortx = Array.new();
  fetch = 0;
  while fetch+7 <= theArray.length do
    seg = theArray[fetch,(8)];
    fortx<<makeByte(seg);
    fetch+=8; #go to the start of next byte.
  end
  return fortx;
end

# calculates CRC on an array witch have bit as elements.
# theArray, is the array on witch the crc is done.
# start, is the position on witch the calculation starts.
# length, is the position on witch the calculation finishes.
def CRC8( theArray, start, length )
  fetch = start; #on most cases = 0
  crc = 0b0; #initial crc value
  tempByte = 0b0;
#  while fetch+7 <= (theArray.length -16 ) do
  while fetch+7 <= length do
    #take 8 bits from the array and make a byte
#    tempseg = theArray.values_at( fetch..((fetch+8)-1) );
    tempseg2 = theArray[fetch,(8)];
#    printf("current seg is: #{tempseg}\n")
#    printf("\ncurrent seg is: #{tempseg2}\n")
    tempByte = makeByte(tempseg2);
#    puts sprintf("%08b", tempByte)
#    print theArray;
#    print("\n");
#    print tempseg;
    crc = crc ^ tempByte;
    fetch+=8; #go to the start of next byte.
  end
#  puts crc;
  return crc;
end

# Extract a byte from an array witch have 8 distinct bit as elements.
# Returns a byte
def makeByte(theArraySeg)
#  print theArraySeg
  theByte = 0b0;
#  print("\n");
  theArraySeg.each{ |item|
    theByte = (theByte << (1)) | item
#    print("\n");
  }
#  print theByte.to_s(2)
  return theByte;
# puts tByte;
# puts sprintf("%08b", tByte)
end

# Accepts an array with decimal values and returns an array
# with the appropriate bits.
# Every value is zero padded to 8 bits.
def decByteArraytoBits(theArray)
  bits_array = Array.new();
  theArray.each{ |elem|
    bits_array << sprintf("%08b", elem);
  }
  return bits_array;
end

def PrintBasicMenu()
  printf("\nThe following commands are supported:\n");
  printf("--1.  See the contents of the messages in Integer Array format (bit segments as integer elements)\n");
  printf("--2.  See the contents of the messages in Bit String format\n");
  printf("--3.  See the contents of the messages in Hash data structure format (not very usefull)\n");
  printf("--4.  See the contents of the messages in raw binary format\n");
  printf("--5.  Transmit the contents of the messages in Serial Line\n");
  printf("Q|q.  To exit program\n");
  printf("type your command input\n");
end

:private
def _implCommand1()
  
  printf("\n");
  printf("You have loaded #{$indPacketsBinArray.size} packets.\n");
  printf("To see an individual packet type from: 1 to #{$indPacketsBinArray.size}, or press 'enter' to see them all.\n");
  inp=gets;
  ParseInnerArrayInput(inp, $indPacketsBinArray);
  print("\n");
  
end

def _implCommand2()
  
  printf("\n");
  printf("You have loaded #{$indPacketsBinStrArray.size} packets.\n ");
  printf("To see an individual packet type from: 1 to #{$indPacketsBinStrArray.size}, or press 'enter' to see them all.\n");
  inp=gets;
  ParseInnerArrayInput(inp, $indPacketsBinStrArray );
  
  print("\n");
  
end

def _implCommand3()
  
  printf("\n");
  printf("You have loaded #{$indPacketsStrArray.size} packets.\n ");
  printf("To see an individual packet type from: 1 to #{$indPacketsStrArray.size}, or press 'enter' to see them all.\n");
  inp=gets;
  ParseInnerArrayInput(inp, $indPacketsStrArray );
  
  print("\n");
  
end

def _implCommand4()
  
  printf("\n");
  printf("You have loaded #{$indPacketsBinArray.size} packets.\n ");
  printf("To see an individual packet type from: 1 to #{$indPacketsBinArray.size}, or press 'enter' to see them all.\n");
  inp=gets;
  PrintRawBin(inp, $indPacketsBinArray );
  print("\n");
  
end

def _implCommand5()
  
  printf("\n");
  printf("You have loaded #{$indPacketsBinArray.size} packets.\n ");
  printf("To transmit an individual packet type from: 1 to #{$indPacketsBinArray.size}, or press 'enter' to transmit them all.\n");
  inp=gets;
  SerialTxRawBin(inp, $indPacketsBinArray, $cmdlnoptions[:serialport], $cmdlnoptions[:bytestuff] );
  print("\n");
  
end