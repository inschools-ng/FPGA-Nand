// combinational logic for LUTs
always @ (input_1 or input_2)
    begin
        and_gate <= input_1 & input_2;
    end

// sequential logic for Flipflops
always @ (posedge i_Clk)
    begin
        and_gate <= input_1 & input_2;
    end

// latch combinational logic

always @ (i_A or i_B)
begin
    if (i_A == 1'b0 && i_B == 1'b0)
        o_Q <= 1'b0;
        else if (i_A == 1'b0 && i_B == 1'b1)
            o_Q <= 1'b1;
        else if (i_A == 1'b1 && i_B == 1'b0)
            o_Q <= 1'b1;


// Proper sequential logic

always @ (posedge i_Clk)
begin
    if (i_A == 1'b0 && i_B == 1'b0)
        o_Q <= 1'b0;
    else if (i_A == 1'b0 && i_B == 1'b1)
        o_Q <= 1'b1;
    else if (i_A == 1'b1 && i_B == 1'b0)
        o_Q <= 1'b1;
end 

// Synchronous resets 

always @ (posedge i_Clk)
begin
    if (i_Reset)
        o_Q <+ 1'b1;
    else 

// Asynchronous resets 

always @ (posedge i_Clk or i_Reset)
    begin
        if (i_Reset)
            o_Q <= 1'b1;
        else


