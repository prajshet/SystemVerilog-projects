// env class for 8b10b encoding, just placehoder class 
class b8_env extends uvm_env;
`uvm_component_utils(b8_env)

b8_agent agent;

sb_dlen dlen_box;
sb_dlen_op dlen_box_op;
sb_io_dl comp_box;

sb_4inital inital4_box;
sb_4inital_out inital4_box_op;
sb_inval inval_box;
sb_5b b5_box;
sb_compar en_compar_box;

sb_in2crc in2crc_box;       //MC
sb_out_crc out_crc_box;     //MC
sb_incrc_encode incrc_encode_box;   //MC
sb_crc_compare crc_compare_box;		//MC

function new(string name = "b8_env", uvm_component parent= null);
	super.new(name,parent);
endfunction:new

function void build_phase( uvm_phase phase);
agent = b8_agent::type_id::create("agent",this);

dlen_box= sb_dlen::type_id::create("dlen_box",this);   // sb 1 i/p
dlen_box_op=sb_dlen_op::type_id::create("dlen_box_op",this);
comp_box=sb_io_dl::type_id::create("comp",this); // sb for comparison

inital4_box= sb_4inital::type_id::create("inital4_box",this);//sb2 i/p
inital4_box_op= sb_4inital_out::type_id::create("inital4_box_op",this);//sb2 _on o/p  

inval_box=sb_inval::type_id::create("inval_box",this); // static invalid vlaue  check

b5_box= sb_5b::type_id::create("b5_box",this); // encoder ref
en_compar_box= sb_compar::type_id::create("en_compar_box",this);//encode comparision

in2crc_box= sb_in2crc::type_id::create("in2crc_box",this);						//MC
out_crc_box= sb_out_crc::type_id::create("out_crc_box",this);   				//MC
incrc_encode_box= sb_incrc_encode::type_id::create("incrc_encode_box",this);	//MC
crc_compare_box= sb_crc_compare::type_id::create("crc_compare_box",this);		//MC

endfunction: build_phase

function void connect_phase(uvm_phase phase);
  agent.monitor.in_po.connect(dlen_box.m2sb_msg.analysis_export);
  agent.monitor.in_po.connect(inital4_box.m2sb_msg.analysis_export);
  agent.monitor.in_po.connect(b5_box.m2sb_eco5.analysis_export);
  
  agent.monitor_out.out_po.connect(inital4_box_op.m2sb_4x281.analysis_export);
  agent.monitor_out.out_po.connect(dlen_box_op.port_dlen_op.analysis_export);
  agent.monitor_out.out_po.connect(inval_box.m2sb_val.analysis_export);
  agent.monitor_out.out_po.connect(en_compar_box.dut_msg.analysis_export);
  
  dlen_box.in_dlen.connect(comp_box.m2sb_in_dl.analysis_export);
  dlen_box_op.dlen_comp.connect(comp_box.m2sb_op_dl.analysis_export);
  b5_box.b5_enco.connect(en_compar_box.my_msg.analysis_export);
    
 
  in2crc_box.in_crc.connect(incrc_encode_box.inp_crc.analysis_export);					//MC
  incrc_encode_box.dis_enc_crc.connect(crc_compare_box.dis_in_crc.analysis_export);		//MC
  incrc_encode_box.idis_enc_crc.connect(crc_compare_box.idis_in_crc.analysis_export);	//MC
  out_crc_box.out_crc.connect(crc_compare_box.output_crc.analysis_export);				//MC 
endfunction: connect_phase

task run_phase (uvm_phase phase);

endtask: run_phase

endclass : b8_env
