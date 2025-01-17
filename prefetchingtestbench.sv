`timescale 1ns/1ps

module ThreeD_Prefetcher_tb;

    // Testbench Parameters
    parameter ADDR_WIDTH = 32;
    parameter X_DIM = 4;
    parameter Y_DIM = 4;
    parameter Z_DIM = 4;

    // Clock and Reset Signals
    logic clock;
    logic reset;

    // DUT Inputs and Outputs
    logic                      valid_i;
    logic [ADDR_WIDTH-1:0]     address_i;
    logic                      ready_o;
    logic [ADDR_WIDTH-1:0]     address_o;

    // Instantiate the DUT (Device Under Test)
    ThreeD_Prefetcher #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .X_DIM(X_DIM),
        .Y_DIM(Y_DIM),
        .Z_DIM(Z_DIM)
    ) dut (
        .clock(clock),
        .reset(reset),
        .valid_i(valid_i),
        .address_i(address_i),
        .ready_o(ready_o),
        .address_o(address_o)
    );

    // Clock Generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10ns clock period
    end

    // Reset Sequence
    initial begin
        reset = 1;
        #15 reset = 0;
    end

    // Test Sequence
    initial begin
        // Wait for reset deassertion
        wait (!reset);

        // Test Case 1: Middle of the 3D grid
        @(posedge clock);
        apply_address(32'h00000010); // Example address in the middle
        #10 check_adjacent('{32'h0000000F, 32'h00000011, 32'h0000000C, 32'h00000014, 32'h0000000B, 32'h00000017});
        
        // Test Case 2: Corner of the 3D grid
        @(posedge clock);
        apply_address(32'h00000000); // Corner address
        #10 check_adjacent('{32'h00000001, 32'h00000004, 32'h00000010});

        // Test Case 3: Edge of the 3D grid
        @(posedge clock);
        apply_address(32'h00000003); // Edge address
        #10 check_adjacent('{32'h00000002, 32'h00000007, 32'h00000013});

        // Test Case 4: Another Middle Point
        @(posedge clock);
        apply_address(32'h00000022); // Another middle point
        #10 check_adjacent('{32'h00000021, 32'h00000023, 32'h0000001E, 32'h00000026, 32'h0000001D, 32'h00000027});

        // Test Case 5: Test Different Dimensions
        @(posedge clock);
        reset = 1; #10 reset = 0; // Reset the DUT to load new parameters
        apply_address(32'h00000012); // Test with new dimensions
        #10 check_adjacent('{32'h00000011, 32'h00000013, 32'h0000000E, 32'h00000016, 32'h0000000D, 32'h00000017});

        $display("All test cases passed.");
        $finish;
    end

    // Apply Address Task
    task apply_address(input logic [ADDR_WIDTH-1:0] addr);
        begin
            valid_i = 1;
            address_i = addr;
            @(posedge clock); // Allow for address setup
            valid_i = 0;
        end
    endtask

    // Check Adjacent Addresses Task
    task check_adjacent(input logic [ADDR_WIDTH-1:0] expected_addresses[]);
        integer i;
        int num_expected;
        begin
            num_expected = expected_addresses.size(); // automatically determine the size of the array
            i = 0;
            while (i <num_expected) begin
                @(posedge clock);
                if (ready_o) begin
                    if (address_o !== expected_addresses[i]) begin
                        $error("Mismatch at index %0d: Expected %h, Got %h", i, expected_addresses[i], address_o);
                    end
                    i++;
                end
            end
        end
    endtask

endmodule
