####################
////////////////////

// Code your design here
module Three_D_Prefetcher #(
  parameter xSize = 3,
  parameter ySize = 3,
  parameter zSize = 3
) (
  input  clock,
  input  reset,
  input  [31:0] address_i,
  output reg [31:0] address_o,
  input  valid,
  output reg ready
);

  // Internal registers and logic
  typedef enum logic [1:0] {IDLE, PREFETCHING, OUTPUT} state_t;
  state_t state, next_state;
  reg [2:0] address_index;
  reg [31:0] addresses[xSize * ySize * zSize - 1:0]; // Fixed-size array
  reg [2:0] num_addresses; // Number of valid adjacent addresses

  // State transitions (moved to combinational logic)
  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        if (valid) begin
          next_state = PREFETCHING;
        end
      end
      PREFETCHING: begin
        if (address_index >= num_addresses) begin
          next_state = IDLE;
        end else begin
          next_state = OUTPUT;
        end
      end
      OUTPUT: begin
        if (address_index >= num_addresses) begin
          next_state = IDLE;
        end else begin
          next_state = OUTPUT;
        end
      end
    endcase
  end

  // State register and output logic
  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      address_index <= 0;
      num_addresses <= 0;
      address_o <= 32'h0;
      ready <= 0;
    end else begin
      state <= next_state;
      
      case (state)
        IDLE: begin
          if (valid) begin
            // Compute adjacent addresses when valid is asserted
            compute_adjacent_addresses(address_i);
            address_index <= 0;
            ready <= 0;
          end
        end
        OUTPUT: begin
          if (address_index < num_addresses) begin
            address_o <= addresses[address_index];
            ready <= 1;
            address_index <= address_index + 1;
          end else begin
            ready <= 0;
          end
        end
      endcase
    end
  end

  // Compute adjacent addresses in the 3D space
  task compute_adjacent_addresses(input [31:0] addr);
    integer x, y, z;
    integer xySize;
    begin
      xySize = xSize * ySize;
      z = addr / xySize;
      y = (addr % xySize) / xSize;
      x = addr % xSize;

      // Reset the number of valid addresses
      num_addresses = 0;

      // Calculate adjacent nodes and store them
      if (x > 0) addresses[num_addresses++] = addr - 1; // Left
      if (x < xSize - 1) addresses[num_addresses++] = addr + 1; // Right
      if (y > 0) addresses[num_addresses++] = addr - xSize; // Down
      if (y < ySize - 1) addresses[num_addresses++] = addr + xSize; // Up
      if (z > 0) addresses[num_addresses++] = addr - xySize; // Front
      if (z < zSize - 1) addresses[num_addresses++] = addr + xySize; // Back
    end
  endtask

endmodule
