# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe "Eye::Process::System" do
  before :each do
    @process = Eye::Process.new(C.p1)
  end
  
  it "load_pid_from_file" do
    File.open(@process[:pid_file_ex], 'w'){|f| f.write("asdf") }
    @process.load_pid_from_file.should == nil

    File.open(@process[:pid_file_ex], 'w'){|f| f.write(12345) }
    @process.load_pid_from_file.should == 12345

    FileUtils.rm(@process[:pid_file_ex]) rescue nil    
    @process.load_pid_from_file.should == nil
  end

  it "set_pid_from_file" do
    File.open(@process[:pid_file_ex], 'w'){|f| f.write(12345) }
    @process.set_pid_from_file
    @process.pid.should == 12345
    @process.pid = nil
  end

  it "save_pid_to_file" do
    @process.pid = 123456789
    @process.save_pid_to_file
    File.read(@process[:pid_file_ex]).to_i.should == 123456789
  end

  it "clear_pid_file" do
    @process.pid = 123456789
    @process.save_pid_to_file
    File.read(@process[:pid_file_ex]).to_i.should == 123456789

    @process.clear_pid_file.should == true
    File.exists?(@process[:pid_file_ex]).should == false
  end

  it "process_realy_running?" do
    @process.pid = $$
    @process.process_realy_running?.should == true

    @process.pid = nil
    @process.process_realy_running?.should == nil

    @process.pid = -123434
    @process.process_realy_running?.should == false
  end

  it "send_signal"

  it "with_timeout" do
    res = @process.with_timeout(0.5) do
      sleep 0.3
      11
    end

    res.should == 11

    res = @process.with_timeout(0.5) do
      sleep 0.7
      11
    end
    res.should == :timeout
  end
end
