// interface file for 8b10b

interface e2t_intf(input reg clk);

reg pushin, startin,reset; //1 bit inputs  

reg [8:0]datain; //higher orderbit is set for k codes.
reg [9:0]dataout;

reg pushout, startout; //1 bit inputs  

modport b8_intf (input clk, input pushin, input startin, input reset,input datain,output pushout, output startout, output dataout);

endinterface :e2t_intf
