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
  printf("--1.  See the contents of the messages in Bit String format\n");
  printf("--2.  See the contents of the messages in String format\n");
  printf("--3.  See the contents of the messages in \n");
  printf("--4.  Transmit the contents of the messages in Serial Line\n");
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
    print("\n2");
  elsif input.to_i ==3  
    print("\n3");
  elsif input.to_i ==4
    print("\n4");
  elsif input == "\n"
    print("\nType a supported command\n");
    PrintBasicMenu();
  else
    printf("\nQuiting\n");
  end
end

def _implCommand1()
  
  printf("\n");
  printf("You have loaded#{$indPacketsBinStrArray.size} packets.\n ");
  
  
  print $indPacketsBinStrArray;
  
  print("\n");
  
end