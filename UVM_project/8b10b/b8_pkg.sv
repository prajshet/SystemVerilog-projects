// 8b_10b common inclued place.
package b8_pkg;

import uvm_pkg::* ;

`include "b8_seq_itm.sv";
`include "in_data.sv";
`include "out_data.sv";
`include "en_data.sv";

`include "b8_seq.sv";
`include "b8_mon_in.sv";
`include "b8_mon_out.sv";

`include "sb_dlen.sv";
`include "sb_dlen_op.sv";
`include "sb_io_dl.sv";
`include "sb_5b.sv";
`include "sb_compar.sv";

`include "sb_4inital.sv";
`include "sb_4inital_out.sv";
`include "sb_inval.sv";

`include "sb_in2crc.sv";		//MC
`include "sb_incrc_encode.sv";	//MC
`include "sb_out_crc.sv";		//MC
`include "sb_crc_compare.sv";	//MC

`include "b8_seqr.sv";
`include "b8_driver.sv";

`include "b8_agent.sv";
`include "b8_env.sv";
`include "b8_test.sv";

endpackage: b8_pkg
