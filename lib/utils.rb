#Returns a two-dimensional array
def CreatePacketSegment( width, height )
  theArray = Array.new( width );
  theArray.map! { Array.new(height)  }
  #return theArray;
end

