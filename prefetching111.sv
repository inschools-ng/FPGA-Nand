// 3D Spatial Prefetcher Module
module ThreeD_Prefetcher #(
    parameter ADDR_WIDTH = 32,     // Width of the address bus
    parameter X_DIM = 3,           // Size in X dimension
    parameter Y_DIM = 3,           // Size in Y dimension
    parameter Z_DIM = 3            // Size in Z dimension
)(
    input  logic                      clock,
    input  logic                      reset,
    input  logic                      valid_i,          // Input address valid signal
    input  logic [ADDR_WIDTH-1:0]     address_i,        // Input address
    output logic                      ready_o,          // Output addresses ready signal
    output logic [ADDR_WIDTH-1:0]     address_o         // Output address
);

    // Internal signals
    typedef enum logic [2:0] {
        IDLE,
        CALCULATE,
        OUTPUT_ADJACENT
    } state_t;

    state_t current_state, next_state;

    logic [ADDR_WIDTH-1:0] base_address;
    logic [2:0]            adj_counter;
    logic [5:0][ADDR_WIDTH-1:0] adjacent_addresses; // Maximum of 6 adjacent addresses
    logic [2:0]            total_adjacent;

    // Compute offsets based on dimensions
    localparam logic [ADDR_WIDTH-1:0] X_OFFSET = 1;
    localparam logic [ADDR_WIDTH-1:0] Y_OFFSET = X_DIM;
    localparam logic [ADDR_WIDTH-1:0] Z_OFFSET = X_DIM * Y_DIM;

    // State Register
    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always_comb begin
        case (current_state)
            IDLE: begin
                if (valid_i)
                    next_state = CALCULATE;
                else
                    next_state = IDLE;
            end

            CALCULATE: begin
                next_state = OUTPUT_ADJACENT;
            end

            OUTPUT_ADJACENT: begin
                if (adj_counter < total_adjacent - 1)
                    next_state = OUTPUT_ADJACENT;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output and Internal Logic
    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            ready_o           <= 1'b0;
            address_o         <= {ADDR_WIDTH{1'b0}};
            base_address      <= {ADDR_WIDTH{1'b0}};
            adj_counter       <= 3'd0;
            total_adjacent    <= 3'd0;
            adjacent_addresses<= '{default: {ADDR_WIDTH{1'b0}}};
        end else begin
            case (current_state)
                IDLE: begin
                    ready_o    <= 1'b0;
                    adj_counter<= 3'd0;
                    if (valid_i) begin
                        base_address <= address_i;
                    end
                end

                CALCULATE: begin
                    total_adjacent = 3'd0;
                    
                    // Calculate adjacent addresses
                    if (base_address >= X_OFFSET) begin
                        adjacent_addresses[total_adjacent] = base_address - X_OFFSET;
                        total_adjacent++;
                    end
                    if (base_address + X_OFFSET < X_DIM * Y_DIM * Z_DIM) begin
                        adjacent_addresses[total_adjacent] = base_address + X_OFFSET;
                        total_adjacent++;
                    end
                    if (base_address >= Y_OFFSET) begin
                        adjacent_addresses[total_adjacent] = base_address - Y_OFFSET;
                        total_adjacent++;
                    end
                    if (base_address + Y_OFFSET < X_DIM * Y_DIM * Z_DIM) begin
                        adjacent_addresses[total_adjacent] = base_address + Y_OFFSET;
                        total_adjacent++;
                    end
                    if (base_address >= Z_OFFSET) begin
                        adjacent_addresses[total_adjacent] = base_address - Z_OFFSET;
                        total_adjacent++;
                    end
                    if (base_address + Z_OFFSET < X_DIM * Y_DIM * Z_DIM) begin
                        adjacent_addresses[total_adjacent] = base_address + Z_OFFSET;
                        total_adjacent++;
                    end
                end

                OUTPUT_ADJACENT: begin
                    ready_o   <= 1'b1;
                    address_o <= adjacent_addresses[adj_counter];
                    adj_counter++;
                    if (adj_counter == total_adjacent) begin
                        ready_o <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule
