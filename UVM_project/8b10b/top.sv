`timescale 1ns/10ps
`include "b8_pkg.sv" 
`include "e2t_intf.sv"
`include "8b10b_encode.sv"
import uvm_pkg::* ;

module top();
reg clk;

e2t_intf intf(.clk(clk));

a8b10b_encode encoder (.m(intf.b8_intf));

always #5 clk = ~clk;

initial begin
clk=1;
end

initial begin		// instance 			caller     path	   name		   value
	uvm_config_db # (virtual e2t_intf):: set (null,  "dut_conn", "my_dut_intf", intf);
	run_test("b8_test"); // start the test environment 
end 

initial begin 
$dumpfile("b.vcd");
$dumpvars();

//$dumpvars(9,top);

end 
endmodule: top
