module ThreeDPrefetcher (
  input clock,
  input reset,
  input [31:0] address_i, // input address
  input valid, // 1 if the input address is valid, else 0
  output reg [31:0] address_o, // output address(es)
  output reg ready // 1 if the output address is valid, else 0
);

  // Define state machine states
  typedef enum logic [1:0] {
    IDLE,
    PREFETCH
  } state_t;
  state_t state, next_state;

  // Adjacent address array
  logic [31:0] adj_addresses [0:5]; // Maximum 6 adjacent addresses
  integer adj_index, num_adj;

  // Define a function to calculate adjacent addresses
  function void calculate_adj_addresses(input [31:0] addr);
    integer x, y, z;
    begin
      // Decode the address into (x, y, z) coordinates
      x = addr % 3;
      y = (addr / 3) % 3;
      z = addr / 9;

      num_adj = 0;
      // Calculate adjacent addresses in x, y, z directions
      if (x > 0) adj_addresses[num_adj++] = addr - 1; // -1 in x direction
      if (x < 2) adj_addresses[num_adj++] = addr + 1; // +1 in x direction
      if (y > 0) adj_addresses[num_adj++] = addr - 3; // -1 in y direction
      if (y < 2) adj_addresses[num_adj++] = addr + 3; // +1 in y direction
      if (z > 0) adj_addresses[num_adj++] = addr - 9; // -1 in z direction
      if (z < 2) adj_addresses[num_adj++] = addr + 9; // +1 in z direction
    end
  endfunction

  // State machine
  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      ready <= 0;
      address_o <= 0;
      adj_index <= 0;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic
  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        if (valid) begin
          calculate_adj_addresses(address_i);
          adj_index = 0;
          ready = 1;
          next_state = PREFETCH;
        end
      end
      PREFETCH: begin
        if (adj_index < num_adj) begin
          address_o = adj_addresses[adj_index];
          adj_index = adj_index + 1;
          ready = 1;
        end else begin
          next_state = IDLE;
          ready = 0;
        end
      end
    endcase
  end

endmodule
