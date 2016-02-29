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
  printf("--4.  See the contents of the messages in raw binary format (vary per terminal)\n");
  printf("--5.  Transmit the contents of the messages in Serial Line\n");
  printf("Q|q.  To exit program\n");
  printf("type your command input\n");
  
end

def ParseArguments()
  if ARGV.size == 0 
    printf("No arguments given, using defaults as:\n");
    printf("--SerialLine to be used is: /dev/ttyUSB0\n");
    printf("--Transmit bits in binary format\n");
  end
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
  if input == "\n"
    
    array.each{ |elem|
      print elem.pack("C*");
    }
  else
    print array[(input.to_i)-1].pack("C*");
  end
end

def SerialTxRawBin( input, array, line )
  if line == nil
    printf("\nNo serial port found, cannot transmit data.\n");
    return;
#    $serialPort.write( $totalPacketsBinArray.pack("C*") );
  end
  if input == "\n"
    array.each{ |elem|
#      print elem.pack("C*");
      $serialPort.write( elem.pack("C*") );
    }
  else
#    print array[(input.to_i)-1].pack("C*");
      $serialPort.write( array[(input.to_i)-1].pack("C*") );
  end
end

#Integer Array format
def _implCommand1()
  
  printf("\n");
  printf("You have loaded #{$indPacketsBinArray.size} packets.\n ");
  printf("To see an individual packet type from: 1 to #{$indPacketsBinArray.size}, or press 'enter' to see them all.\n")
  
  inp=gets;
  ParseInnerArrayInput(inp, $indPacketsBinArray );
  
  print("\n");
  
end

private
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
  SerialTxRawBin(inp, $indPacketsBinArray, $serialPort );
  
  print("\n");
  
end