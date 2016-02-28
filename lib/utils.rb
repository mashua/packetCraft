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