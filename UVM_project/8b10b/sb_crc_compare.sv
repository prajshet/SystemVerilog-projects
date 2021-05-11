class sb_crc_compare extends uvm_scoreboard ;
`uvm_component_utils(sb_crc_compare)

uvm_tlm_analysis_fifo # (reg [39:0]) dis_in_crc;
uvm_tlm_analysis_fifo # (reg [39:0]) idis_in_crc;
uvm_tlm_analysis_fifo # (reg [39:0]) output_crc;

logic [39:0] d_in_crc;
logic [39:0] id_in_crc;
logic [39:0] out_crc;

function new(string name = "sb_crc_compare", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
    dis_in_crc=new("dis0_in_crc",this);
    idis_in_crc=new("dis1_in_crc",this);
    output_crc=new("full_output_crc",this);
endfunction :build_phase

task run_phase(uvm_phase phase);
	forever begin
        dis_in_crc.get(d_in_crc);
        idis_in_crc.get(id_in_crc);
        output_crc.get(out_crc);
        //`uvm_info("crc_compare",$sformatf("crc compare. output crc:%d,input crc1:%d,input crc2:%d",out_crc,d_in_crc,id_in_crc),UVM_MEDIUM)
        if((out_crc!=d_in_crc)&&(out_crc!=id_in_crc)) begin
            `uvm_fatal("crc_mismatch",$sformatf("crc mismatch. output crc:%h,input crc1:%h,input crc2:%h",out_crc,d_in_crc,id_in_crc))
        end
	end
endtask:run_phase
endclass: sb_crc_compare
