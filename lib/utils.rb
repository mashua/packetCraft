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
#    $serialPort.read_timeout=0; #read data as soon they appear on the rx line.
    #Spawn the serial line listener thread.
    #a call to Thread.sleep() is not needed because the
    #loop is blocking at its own, on the Serial.read() call.
    x = Thread.new() {      
#      $serialPort2 = SerialPort.new(serialline, 9600, 8, 1, SerialPort::NONE);
      $serialPort.read_timeout=0; #read data as soon they appear on the rx line.
      dataA = Array.new();
      frameseen=0;
      loop do #keep polling the rx line.
#        printf("\nbefore\n");
        incmData = $serialPort.read($serialPort.data_bits);
#        incmData = $serialPort.read(1);
        printf("\nthe read data are:#{incmData.unpack("C*")}\n");
        if incmData.unpack("C*").eql?(FRAME_DEL_B_A);
          printf("\nDISCARING FRAME\n");
          frameseen+=1;
#        elsif incmData.unpack("C*").eql?(FRAME_ESCAPE_B_A);
        else
          if frameseen==2
            printf("\n\nThe received message is#{ byteDestuff( Array.new(dataA))}\n\n");
            dataA.clear;
            frameseen=0;
          else
            incmData.unpack("C*").each{ |elem|
              dataA.push(elem);
              printf("\ndata in dataArray are:#{data.inspect}")
            }
          end
          
        end
#        $serialPort.flush_input();
#        $serialPort.flush_output();
#        printf("\n#{incmData}\n");
      end
#      $serialPort2 = Serial.new
#      while true
#        puts "func1 at: #{Time.now}"
#        sleep(1);
#      end
    }; x.run;
  rescue
    $serialPort= nil;
    print("Serial port (or at least something emulating) is not availiable on this system,"\
          "continuing without serial transmition/reception support.\n");
  end
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

def PrintBasicMenu()
  
  printf("\nThe following commands are supported:\n");
  printf("--1.  See the contents of the messages in Integer Array format (bit segments as integer elements)\n");
  printf("--2.  See the contents of the messages in Bit String format\n");
  printf("--3.  See the contents of the messages in Hash data structure format (not very usefull)\n");
  printf("--4.  See the contents of the messages in raw binary format (varies per terminal)\n");
  printf("--5.  Transmit the contents of the messages in Serial Line\n");
  printf("Q|q.  To exit program\n");
  printf("type your command input\n");
  
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
#array, holds the array of messages.
#line, holds the Serial line to use for tx-ition
#bytestuff, true for byte stuffing before tx-ition, false else.
def SerialTxRawBin( input, array, line, bytestuff )
  
  if line == nil
    printf("\nNo serial port found, cannot transmit data.\n");
    return;
  end
  if input == "\n" #tx all packets.
    if bytestuff==TRUE
      array.each{ |elem|
        $serialPort.write( byteStuff(Array.new(elem)).pack("C*") );
#        printf("#{elem.pack("C*")}"); 
      }  
    elsif    
      array.each{ |elem|
        $serialPort.write( elem.pack("C*") );
#        printf("#{elem.pack("C*")}");
      }
    end
  else #tx a specific packet.
  begin  
    if bytestuff==TRUE
      $serialPort.write( byteStuff(Array.new(array[(input.to_i)-1])).pack("C*") );
#      printf("#{array[(input.to_i)-1].pack("C*")}");
    elsif
      $serialPort.write( array[(input.to_i)-1].pack("C*") );
#      printf("#{array[(input.to_i)-1].pack("C*")}");
    end
  rescue
      printf("\nnon-existant packet selected");
  end
  end
end

#The frame boundary octet is 01111110, (0x7E in hexadecimal notation)
#A "control escape octet", has the bit sequence '01111101', (0x7D hexadecimal).
#If either of these two octets appears in the transmitted data, an escape octet is sent, 
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
#    print tempseg;
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

private
#Integer Array format
def _implCommand1()
  
  printf("\n");
  printf("You have loaded #{$indPacketsBinArray.size} packets.\n ");
  printf("To see an individual packet type from: 1 to #{$indPacketsBinArray.size}, or press 'enter' to see them all.\n")
  
  inp=gets;
  ParseInnerArrayInput(inp, $indPacketsBinArray );
  
  print("\n");
  
end

def _implCommand2()
  
  printf("\n");
  printf("You have loaded #{$indPacketsBinStrArray.size} packets.\n ");
  printf("To see an individual packet type from: 1 to #{$indPacketsBinStrArray.size}, or press 'enter' to see them all.\n")
  
  inp=gets;
  ParseInnerArrayInput(inp, $indPacketsBinStrArray );
  
  print("\n");
  
end

def _implCommand3()
  
  printf("\n");
  printf("You have loaded #{$indPacketsStrArray.size} packets.\n ");
  printf("To see an individual packet type from: 1 to #{$indPacketsStrArray.size}, or press 'enter' to see them all.\n")
  
  inp=gets;
  ParseInnerArrayInput(inp, $indPacketsStrArray );
  
  print("\n");
  
end

def _implCommand4()
  
  printf("\n");
  printf("You have loaded #{$indPacketsBinArray.size} packets.\n ");
  printf("To see an individual packet type from: 1 to #{$indPacketsBinArray.size}, or press 'enter' to see them all.\n")
  
  inp=gets;
  PrintRawBin(inp, $indPacketsBinArray );
  print("\n");
  
end

def _implCommand5()
  
  printf("\n");
  printf("You have loaded #{$indPacketsBinArray.size} packets.\n ");
  printf("To transmit an individual packet type from: 1 to #{$indPacketsBinArray.size}, or press 'enter' to transmit them all.\n")
  inp=gets;
  SerialTxRawBin(inp, $indPacketsBinArray, $cmdlnoptions[:serialport], $cmdlnoptions[:bytestuff] );
  print("\n");
  
end

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#  printf("\n\n");
#  stst = sprintf("%0#{8}b", 0x7e)
#  ststar = stst.chars
#  print ststar
#  ststar.each_with_index { |ar,el|
#    ststar[el.to_i] = ststar[el.to_i].to_i ;
#  };
#  printf("\n\n");
#  print ststar;
#  printf("%0#{8}b", 0x7e);
#  printf("\n\n");  
#  print $indPacketsBinArray[0]
#  printf("\n\n");
#  print $indPacketsBinArray[1]
#  printf("\n\n");
#  print $indPacketsBinArray[2]
#  printf("\n\n");