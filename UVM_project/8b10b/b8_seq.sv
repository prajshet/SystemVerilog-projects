class b8_seq extends uvm_sequence #(b8_seq_itm);
`uvm_object_utils(b8_seq)

b8_seq_itm itm	; //item instance

	function new (string name = "b8_seq");
	super.new(name);       
	endfunction:new

task en_reset ();   // reset
		start_item(itm);
		itm.typ=reset;
		finish_item(itm);
endtask: en_reset

task en_0crt(); // 28.1=8'h3c
		start_item(itm);
		itm.typ=c0;
		finish_item(itm);
endtask: en_0crt

task en_1crt(); //28.5=8'hbc
		start_item(itm);
		itm.typ=c1;
		finish_item(itm);
endtask: en_1crt

task en_data0(); // data is 0 
		start_item(itm);
		itm.typ=dat0;
		finish_item(itm);
endtask: en_data0

task en_data(); // rand data
		start_item(itm);
		itm.randomize()with{dat1.size >0;
							dat1.size <32;
							foreach (dat1[i]) dat1[i]== i;}; 
		itm.dlen = itm.dat1.size();
		itm.typ=rdat;
		finish_item(itm);
endtask: en_data

task en_dif_data(); // rand data
		start_item(itm);
		itm.randomize()with{dat1.size >0;
							dat1.size <255;
							foreach(dat1[i]) dat1[i][8]==0;
							}; 
		itm.dlen = itm.dat1.size();
		itm.typ=rdat;
		finish_item(itm);
endtask: en_dif_data

task en_vh_cmd(); // rand cmd excluding 13c 1bc and 23.7  
		start_item(itm);
		assert(itm.randomize()with {
		dat1.size inside {1} ; 
		(dat1[$][8]==1'b1) && dat1[$][7:0] inside{8'h1c,8'h5c,8'h7c,8'h9c,8'hdc,8'hfc,8'hfb,8'hfd,8'hfe};
									});
		itm.dlen = itm.dat1.size();
		itm.typ=rdat;
		finish_item(itm);
endtask: en_vh_cmd

task en_delay(); // delay 1 cycle
		start_item(itm);
		itm.typ=delay;
		finish_item(itm);
endtask: en_delay

task make_frm0(); // making frame of 0
		repeat(4) en_0crt(); 
		repeat($urandom_range(0,6)) en_data0();
		en_1crt;
		repeat (10) en_delay();
endtask:make_frm0

task make_frm(b8_seq_itm m); // making frame of 1
		repeat(4) en_0crt();   
		en_data();
		en_1crt;
		repeat (10) en_delay();
endtask:make_frm

task make_dif_frm(b8_seq_itm m); // making frame of 1
		repeat(4) en_0crt();   
		en_data();
		repeat($urandom_range(1,8)) en_vh_cmd();
		repeat($urandom_range(1,32)) en_dif_data();
		en_1crt;
		repeat ($urandom_range(10,32)) en_delay();
endtask:make_dif_frm

task body();
		itm= b8_seq_itm::type_id::create("itm");
		repeat(5) en_reset();
	
		//repeat(10) make_frm0();	
		
		//repeat(20) make_frm(itm);
		
		repeat(2)make_dif_frm(itm);
		
endtask :body

endclass:b8_seq
