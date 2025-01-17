/// Spatial prefetchers are useful for prefectching data from multidimensional memories
/// Here, we developed a prefetcher for 3D spatial algorithms that outputs all adjacent addresses when supplied an address location as an input. 
///



  	initial begin
  		$dumpfile("dump.vcd");
  		$dumpvars;
  		#10000 $finish;
	end