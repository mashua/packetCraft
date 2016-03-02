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
rescue
  $serialPort= nil;
  print("Serial port (or at least something emulating) is not availiable on this system,"\
        "continuing without serial transmition support.\n");
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
        $serialPort.write( byteStuff(elem).pack("C*") );
#        printf("#{elem.pack("C*")}");
      }  
    elsif    
      array.each{ |elem|
        $serialPort.write( elem.pack("C*") );
#        printf("#{elem.pack("C*")}");
      }
    end
  else #tx a specific packet.
    if bytestuff==TRUE
      $serialPort.write( byteStuff(array[(input.to_i)-1]).pack("C*") );
#      printf("#{array[(input.to_i)-1].pack("C*")}");
    elsif
      $serialPort.write( array[(input.to_i)-1].pack("C*") );
#      printf("#{array[(input.to_i)-1].pack("C*")}");
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
# frame delimeters 0x7E, 0xb01111110, '~'
# escape delimeter 0x7D, 0xb1111101, '}'
#FRAME_DEL_H = 0x7E
#FRAME_DEL_B = 0b01111110
#FRAME_ESCAPE_H = 0x7D
#FRAME_ESCAPE_B = 0b01111101
  
#  print $indPacketsBinArray[0];
#    printf("\n\n");
  array = $indPacketsBinArray[0];
#  printf("Array size is: #{array.length}\n");
  fetch = 0;
#  iniarraylen = array.length; #keep the initial array length, because it might change
#  print("\n current array length is:#{array.length}\n")
#  for times in 1..(array.length/8)

while fetch+7 <= array.length do 
#     print("\n current array length is:#{array.length}\n")
#    printf("Fetch time #{times}, and fetch is from: #{fetch} to #{fetch+7} \n")
#    tempseg = array.values_at( fetch..(times*8)-1 );
    tempseg = array.values_at( fetch..(fetch+8)-1 );
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