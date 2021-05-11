// scoreboard that takes in the input_data, converts the data into 32 bit CRC
`include "CRCtable.sv";

class sb_in2crc extends uvm_scoreboard ;
`uvm_component_utils(sb_in2crc)

uvm_tlm_analysis_fifo # (in_data) in_msg;
uvm_analysis_port #(reg [31:0]) in_crc;

in_data indata;
reg [31:0] crc;
reg [31:0] invertcrc;
reg [31:0] crctable;
reg [5:0] i;

function new(string name = "sb_in2crc", uvm_component parent= null);
	super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
	in_msg=new("input_data",this);
	in_crc=new("crc_in2crc",this);	
endfunction : build_phase

task run_phase(uvm_phase phase);
    crc = 32'hffffffff;
	forever begin
		in_msg.get(indata);	
		if((indata.si_data != 9'h13c) && (indata.si_data != 9'h1bc)) begin
        //performs the crc algorithm using the crc table
            crctable = crcTable((crc ^ indata.si_data) & 8'hff);
            crc = (crc>>>8) ^ crctable;
		end	else if (indata.si_data==9'h1bc) begin
            //crc = crc ^ 32'hffffffff;   //invert the bits if you hit the end frame
            //`uvm_info("crc",$sformatf("crc: %h",crc),UVM_MEDIUM)
            in_crc.write(crc);    //output the final crc
            crc = 32'hffffffff;         //reset the crc    
        end
	end
endtask:run_phase
endclass: sb_in2crc
