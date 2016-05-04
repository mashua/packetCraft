require 'serialport'

require_relative '../lib/utils.rb'

class RSpecGreeter
  def greet
    "Hello RSpecj!"
  end
end

#$serialPort
serialline = "/dev/ttyUSB2";
#$serialPort = SerialPort.new(serialline, 9600, 8, 1, SerialPort::NONE);

ClaimSerialPort( serialline );

describe "OBC Scheduling Service" do
  it "should say 'Hello RSpec!' when it receives the greet() message" do
    greeter = RSpecGreeter.new
    greeting = greeter.greet
    greeting.should == "Hello RSpec!"
    
  end
end


#describe "TennisScorer", "basic scoring" do
#  it "should start with a score of 0-0" do
#    puts "OK!"
#  end
#  it "should be 15-0 if the server wins a point"
#  it "should be 0-15 if the receiver wins a point"
#  it "should be 15-15 after they both win a point"
#end