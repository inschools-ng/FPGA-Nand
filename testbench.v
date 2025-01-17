// the following is a testbench to exercise our project and make sure it works as expected. 
// it instatiates the unit under test (UUT)
// and simulates the inputs
// while monitoring the the outputs

// In this example, we want the testbench to simulate the unstable inputs from a bouncing switch,
// so we can confirm that the debounce filter is delaying the output 
// until the switch has settled into a stable state.

module Debounce_Filter_TB ();
    // this testbench provides a clock signal to the UUT and other inputs
    reg r_Clk = l'b0, r_Bouncy = l'b0; // create a clock signal
    always #2 r_Clk <= !r_Clk; // signal inverts every 2ns for a clock period of 4ns per cycle
    // Instatiating UUT, we override the DEBOUNCE_LIMIT with the value of 4
    // This means that the DEBOUNCE filter will only look 
    // for 4 clock cycles of stability 
    // before it deems the output as debounced and stable
    Debounce_Filter_TB #(.DEBOUNCE_LIMIT(4)) UUT 
    (.i_Clk(r_Clk)),
    .i_Bouncy(r_Bouncy),
    .o_Debounced(w_Debounced));
    
    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        repeat(3) @(posedge r_Clk);

        r_Bouncy <= 1'b1;   // toggle state of input pin
            @(posedge r_Clk);

        r_Bouncy <= 1'b0; // simulate a glitch/bounce of switch
            @(posedge r_Clk);

        r_Bouncy <= 1'b1; // bounce goes away 
            repeat(6) @(posedge r_Clk);
            $display("Test Complete");
            $finish();

    end
endmodule;



