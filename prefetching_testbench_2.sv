module tb_spatial_3d_prefetcher;

    // Testbench parameters
    parameter s_word = 256;
    parameter X_SIZE = 3;
    parameter Y_SIZE = 3;
    parameter Z_SIZE = 3;

    // DUT signals
    logic clk;
    logic rst;
    logic [31:0] address_i;
    logic valid;
    logic [31:0] address_o;
    logic ready;

    // Instantiate the DUT
    spatial_3d_prefetcher #(
        .s_word(s_word),
        .X_SIZE(X_SIZE),
        .Y_SIZE(Y_SIZE),
        .Z_SIZE(Z_SIZE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .address_i(address_i),
        .valid(valid),
        .address_o(address_o),
        .ready(ready)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Task to apply a test vector
    task apply_test_vector(input [31:0] addr);
        begin
            address_i = addr;
            valid = 1;
            #10 valid = 0;
        end
    endtask

    // Task to wait for and check all adjacent addresses
    task check_adjacent_addresses(input [31:0] expected_addresses[]);
        integer i;
        begin
            i = 0;
            wait (ready);
            while (ready && i < expected_addresses.size()) begin
                $display("Checking adjacent address %0d: Expected %h, Got %h", 
                         i, expected_addresses[i], address_o);
                assert(address_o == expected_addresses[i]) 
                    else $error("Mismatch at index %0d: Expected %h, Got %h", 
                                i, expected_addresses[i], address_o);
                i++;
                #10;
            end
        end
    endtask

    // Test vectors
    initial begin
        // Initialize signals
        rst = 1;
        valid = 0;
        address_i = 0;

        // Reset DUT
        #10 rst = 0;

        // Test 1: Middle node (1,1,1) in a 3x3x3 grid
        #10;
        apply_test_vector(13); // Address 13 corresponds to (1,1,1)
        check_adjacent_addresses('{12, 14, 10, 16, 4, 22}); // Expected adjacent addresses

        // Test 2: Corner node (0,0,0) in a 3x3x3 grid
        #10;
        apply_test_vector(0); // Address 0 corresponds to (0,0,0)
        check_adjacent_addresses('{1, 3, 9}); // Expected adjacent addresses

        // Test 3: Edge node (2,2,2) in a 3x3x3 grid
        #10;
        apply_test_vector(26); // Address 26 corresponds to (2,2,2)
        check_adjacent_addresses('{25, 23, 17}); // Expected adjacent addresses

        // Additional test cases can be added here...

        // Finish the simulation
        #10 $finish;
    end
endmodule
