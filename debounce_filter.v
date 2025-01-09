
// this module removes bounces in the input 
// and creates a stable output
// DEBOUNCE_LIMIT is the number of clock cycles 
// clock cycles is equal to the the time divided by the clock period of the FPGA

module Debounce_Filter #(parameter DEBOUNCE_LIMIT = 20) (
    input i_Clk,
    input i_Bouncy,
    output o_Debounced);

    // to create the clock cycle counter 
    // we use the ceiling log base 2
    // this determines the rounded log2 value of the number of clock cycles
    // this tells us the number of binary digits needed to 
    // implement the counter.


    // the @clog2 function dynamically sizes the r_count register based 
    // on the input parameter



  	reg [$clog2(DEBOUNCE_LIMIT)-1:0] r_Count = 0;
    reg r_State = 1'b0;
    
    // at each clock cycle, 
    always @(posedge i_Clk)
    begin
    // if the input is different from the output (changing input),
    // but the r_count is less than the DEBOUNCE_LIMIT-1,
    // it means we have not waited for the desired amount
    // of time for the switch to stop bouncing    
    if (i_Bouncy !== r_State && r_Count < DEBOUNCE_LIMIT-1)
        begin
            // increment the clock cycle counter by 1
            r_Count <= r_Count + 1;
        end 
    //  if the counter has reached its limit,
    //  we have waited the desired amount of time 
    //  for the switch to stop bouncing
    else if (r_Count == DEBOUNCE_LIMIT-1) 
        begin
            // we register the current value of the input (i_Bouncy)
            // to r_State
            // in turn r_state value is assigned to the output (o_Debounced)
            // we also reset the counter to 0 to prepare for the next event
            r_State <= i_Bouncy;
            r_Count <= 0;
        end 
        // This covers situation where the input and the output have the same state
        else
        begin
            // We reset the counter here
            // this is because there is nothing to debounce and
            // we want the debbounce filter to always be reasdy for
            //the next event
            
            r_Count <= 0;
        end
    end 

    assign o_Debounced = r_State;

endmodule

       


