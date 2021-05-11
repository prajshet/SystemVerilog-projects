//sb_out_crc takes in the output data and extracts the crc from it
class sb_out_crc extends uvm_scoreboard ;
`uvm_component_utils(sb_out_crc)

uvm_tlm_analysis_fifo # (out_data) out_msg;
uvm_analysis_port #(reg [39:0]) out_crc;

out_data outdata;
reg [39:0] crc;
reg [3:0] counter;

function new(string name = "sb_out_crc", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
	out_msg=new("output_data",this);
    out_crc=new("crc_out_crc",this);
endfunction :build_phase

task run_phase(uvm_phase phase);
	counter = 0;
	forever begin
		out_msg.get(outdata);
        if((outdata.b10_data==10'h3A8) || (outdata.b10_data==10'h057)) begin
            counter = 1;
        end else if(counter > 0 && counter < 5) begin
            case(counter)
                1: crc[39:30] = outdata.b10_data;
                2: crc[29:20] = outdata.b10_data;
                3: crc[19:10] = outdata.b10_data;
                4: begin
                   crc[9:0] = outdata.b10_data;
                   out_crc.write(crc);
                   end
            endcase
            counter = counter + 1;
        end else begin
            counter = 0;
        end
	end
endtask:run_phase
endclass: sb_out_crc
