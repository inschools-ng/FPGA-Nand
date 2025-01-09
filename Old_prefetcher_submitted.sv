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

  // internal registers
  typedef enum logic [1:0] {IDLE, PREFETCHING, OUTPUT} state_t;
  state_t state, next_state;
  reg [2:0] address_index;
  reg [31:0] addresses[xSize * ySize * zSize - 1:0]; 
  reg [2:0] num_addresses; 

  // state transitions - FSM - 
  // most Interesting part of this design is the state transition
  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        if (valid) begin
          if (check_bounds(address_i)) begin
            next_state = PREFETCHING;
          end else begin
            next_state = IDLE; // here, the state stays in IDLE if address is found to be invalid
          end
        end
      end
      PREFETCHING: begin
        if (num_addresses > 0 && address_index < num_addresses) begin
          next_state = OUTPUT;
        end else begin
          next_state = IDLE; // here, the state also goes back to 
          // IDLE if there are no valid addresses found or 
          // if it's not done prefetching
        end
      end
      OUTPUT: begin
        if (address_index >= num_addresses) begin
          next_state = IDLE; // lastly, the state goes back to 
          // IDLE after outputting all addresses
        end else begin
          next_state = OUTPUT;
        end
      end
    endcase
  end

  // state registers - buffer - Buffalo W
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
          ready <= 0; // very important to do this
          if (valid) begin // check for bounds first
            if (check_bounds(address_i)) begin
              compute_adjacent_addresses(address_i); // compute adjacent addresses
              address_index <= 0;
            end else begin
              num_addresses <= 0; // there should be no valid addresses if out of bounds
              address_o <= 32'h0; // clears address_o if invalid address
              ready <= 1; // this indicates any invalid address has been processed
            end
          end
        end
        // Could comment the entire PREFETCHING block here
        PREFETCHING: begin
          // This state is brief and 
          // doesn't really do much
          // mainly sets up the transition to OUTPUT
        end
        // really important state - OUTPUT
        OUTPUT: begin
          if (address_index < num_addresses) begin
            address_o <= addresses[address_index];
            ready <= 1;
            address_index <= address_index + 1;
          end else begin
            ready <= 0; // ready set to 0
          end
        end
      endcase
    end
  end

  // modular logic block to check if the input address is within bounds of the grids
  // 
  function logic check_bounds(input [31:0] addr);
    integer x, y, z;
    integer xySize;
    begin
      xySize = xSize * ySize;
      z = addr / xySize;
      y = (addr % xySize) / xSize;
      x = addr % xSize;
      check_bounds = (x < xSize) && (y < ySize) && (z < zSize);
    end
  endfunction

  // this is the aprefetching algorithm 
  // this computes adjacent addresses in the 3D space
  task compute_adjacent_addresses(input [31:0] addr);
    integer x, y, z;
    integer xySize;
    begin
      xySize = xSize * ySize;
      z = addr / xySize;
      y = (addr % xySize) / xSize;
      x = addr % xSize;

      // resets the number of valid addresses
      num_addresses = 0;

      // need to store the nodes after calculating them
      if (x > 0) addresses[num_addresses++] = addr - 1; //ELFT is LEFT and FELT and TEFL and EFLT and TLFE and ...
      if (x < xSize - 1) addresses[num_addresses++] = addr + 1; // // to the neighbour on my RIGHT...lisstening to metal...smh
      if (y > 0) addresses[num_addresses++] = addr - xSize; // for those who drive into LOWER LOWER LOWEST Wacker Drive
      if (y < ySize - 1) addresses[num_addresses++] = addr + xSize; // come see UPPER Manhattan...
      if (z > 0) addresses[num_addresses++] = addr - xySize; // ?? the guy at the frFRONTt porch
      if (z < zSize - 1) addresses[num_addresses++] = addr + xySize; // Rick and Morty is soooo BACK!!
    end
  endtask

endmodule
