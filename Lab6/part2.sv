// Compute AX^2 + BX + C using a custom datapath (a series of registers, muxes, and an ALU), and a custom
// control path (implemented using a finite state machine)

// Top-level module: simulate the mathematical operation AX^2 + BX + C on an ALU, implementing the control path with an FSM
module part2(input logic Clock, Reset, Go, input logic [7:0] DataIn, DataResult, output logic ResultValid);
    // lots of wires to connect our datapath and control
    logic ld_a, ld_b, ld_c, ld_x, ld_r;
    // TODO: Add other ld_* signals you need here.
    logic ld_alu_out;
    logic [1:0] alu_select_a, alu_select_b;
    logic alu_op;

    // Instantiate the control path
    control C0(
        .clk(Clock),
        .reset(Reset),

        .go(Go),

        .ld_alu_out(ld_alu_out),
        
        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_c(ld_c),
        .ld_x(ld_x),
        .ld_r(ld_r),
        
        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),
        .alu_op(alu_op),
        .result_valid(ResultValid)
    );

    // Instantiate the datapath
    datapath D0(
        .clk(Clock),
        .reset(Reset),

        .ld_alu_out(ld_alu_out),
        
        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_c(ld_c),
        .ld_x(ld_x),
        .ld_r(ld_r),

        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),
        .alu_op(alu_op),

        .data_in(DataIn),
        .data_result(DataResult)
    );

 endmodule

// Control path module: uses an FSM to control different states
module control(input logic clk, reset, go, output logic ld_a, ld_b, ld_c, ld_x, ld_r, ld_alu_out, output logic [1:0] alu_select_a,
    alu_select_b, output logic alu_op, output logic result_valid);

    // Enumeration of FSM states
    typedef enum logic [3:0]  { S_LOAD_A_RST    = 'd0,
                                S_LOAD_A        = 'd1,
                                S_LOAD_A_WAIT   = 'd2,
                                S_LOAD_B        = 'd3,
                                S_LOAD_B_WAIT   = 'd4,
                                S_LOAD_C        = 'd5,
                                S_LOAD_C_WAIT   = 'd6,
                                S_LOAD_X        = 'd7,
                                S_LOAD_X_WAIT   = 'd8,
                                S_CYCLE_0       = 'd9,
                                S_CYCLE_1       = 'd10,
                                S_CYCLE_2       = 'd11,
                                S_CYCLE_3       = 'd12,
                                S_CYCLE_4       = 'd13,
                                S_CYCLE_5       = 'd14} statetype;
                                
    statetype current_state, next_state;                            

    // Next state logic, aka: state table
    always_comb begin
        case (current_state)
            // Go indicates that a new data value is ready
            S_LOAD_A_RST: next_state = go ? S_LOAD_A_WAIT : S_LOAD_A_RST; // Loop in current state until value is input
            S_LOAD_A: next_state = go ? S_LOAD_A_WAIT : S_LOAD_A; // Loop in current state until value is input
            S_LOAD_A_WAIT: next_state = go ? S_LOAD_A_WAIT : S_LOAD_B;
            S_LOAD_B: next_state = go ? S_LOAD_B_WAIT : S_LOAD_B;
            S_LOAD_B_WAIT: next_state = go ? S_LOAD_B_WAIT : S_LOAD_C;
            S_LOAD_C: next_state = go ? S_LOAD_C_WAIT : S_LOAD_C;
            S_LOAD_C_WAIT: next_state = go ? S_LOAD_C_WAIT : S_LOAD_X;
            S_LOAD_X: next_state = go ? S_LOAD_X_WAIT : S_LOAD_X;
            S_LOAD_X_WAIT: next_state = go ? S_LOAD_X_WAIT : S_CYCLE_0;
            
            // Computation states
            S_CYCLE_0: next_state = S_CYCLE_1;
            S_CYCLE_1: next_state = S_CYCLE_2;
            S_CYCLE_2: next_state = S_CYCLE_3;
            S_CYCLE_3: next_state = S_CYCLE_4;
            S_CYCLE_4: next_state = S_CYCLE_5;
            S_CYCLE_5: next_state = S_LOAD_A;
            default: next_state = S_LOAD_A_RST;
        endcase
    end // state_table

    // output logic logic: the datapath control signals for each state
    always_comb begin
        // By default, make all signals 0
        ld_alu_out = 1'b0;
        ld_a = 1'b0;
        ld_b = 1'b0;
        ld_c = 1'b0;
        ld_x = 1'b0;
        ld_r = 1'b0;
        alu_select_a = 1'b0;
        alu_select_b = 1'b0;
        alu_op       = 1'b0;
        result_valid = 1'b0;

        case (current_state)
            S_LOAD_A_RST: begin
                ld_a = 1'b1;
            end
            S_LOAD_A: begin
                ld_a = 1'b1;
                result_valid = 1'b1;
            end
            S_LOAD_B: begin
                ld_b = 1'b1;
            end
            S_LOAD_C: begin
                ld_c = 1'b1;
            end
            S_LOAD_X: begin
                ld_x = 1'b1;
            end
            S_CYCLE_0: begin // Do B <- B * X
                ld_alu_out = 1'b1;
                ld_b = 1'b1; // store result back into B
                alu_select_a = 2'b01; // Select register B
                alu_select_b = 2'b11; // Also select register X
                alu_op = 1'b1; // Do multiply operation
            end
            S_CYCLE_1: begin // Do A <- A * X
                ld_alu_out = 1'b1; 
                ld_a = 1'b1; // store result back into A
                alu_select_a = 2'b00; // Select register A
                alu_select_b = 2'b11; // Also select register X
                alu_op = 1'b1; // Do multiply operation
            end
            S_CYCLE_2: begin // Do A <- A * X (with updated A value from before)
                ld_alu_out = 1'b1;
                ld_a = 1'b1; // store result back into A
                alu_select_a = 2'b00; // Select register A
                alu_select_b = 2'b11; // Also select register X
                alu_op = 1'b1; // Do multiply operation
            end
            S_CYCLE_3: begin // Do A <- A + B (with updated A value from before)
                ld_alu_out = 1'b1; 
                ld_a = 1'b1; // store result back into A
                alu_select_a = 2'b00; // Select register A
                alu_select_b = 2'b01; // Also select register B
                alu_op = 1'b0; // Do add operation
            end
            S_CYCLE_4: begin // Do R = A + C (with updated A value from before)
                ld_r = 1'b1; // store result into register R
                alu_select_a = 2'b00; // Select register A
                alu_select_b = 2'b10; // Also select register C
                alu_op = 1'b0; // Do add operation
            end
        // Don't need a default case since we already made sure all of our outputs were assigned a value at the start of the always block.
        endcase
    end // enable_signals

    // current_state logicisters
    always_ff@(posedge clk) begin
        if(reset)
            current_state <= S_LOAD_A_RST;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

// Data path module: implements a series of registers, muxes and an ALU to help compute our result
module datapath(input logic clk, reset, input logic [7:0] data_in, input logic ld_alu_out, ld_a, ld_b, ld_c, ld_x, 
    ld_r, alu_op, input logic [1:0] alu_select_a, alu_select_b, output logic [7:0] data_result);

    // input logic logicisters
    logic [7:0] a, b, c, x;

    // output logic of the alu
    logic [7:0] alu_out;

    // alu input logic muxes
    logic [7:0] alu_a, alu_b;

    // registers a, b, c and x with associated logic
    always_ff @(posedge clk) begin
        if(reset) begin
            a <= 8'b0;
            b <= 8'b0;
            c <= 8'b0;
            x <= 8'b0;
        end
        else begin
            if(ld_a) a <= ld_alu_out ? alu_out : data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_b) b <= ld_alu_out ? alu_out : data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if (ld_c) c <= data_in; // load data_in always
            if (ld_x) x <= data_in; // load data_in always
        end
    end

    // output logic result logicister
    always@(posedge clk) begin
        if(reset) begin
            data_result <= 8'b0;
        end
        else
            if(ld_r)
                data_result <= alu_out;
    end

    // The ALU input logic multiplexers: to select which register values will be transferred to the ALU as inputs
    always_comb begin
        case (alu_select_a)
            0: alu_a = a;
            1: alu_a = b;
            2: alu_a = c;
            3: alu_a = x;
            default: alu_a = 8'b0;
        endcase

        case (alu_select_b)
            0: alu_b = a;
            1: alu_b = b;
            2: alu_b = c;
            3: alu_b = x;
            default: alu_b = 8'b0;
        endcase
    end

    // The ALU
    always_comb begin : ALU
        case (alu_op)
            0: alu_out = alu_a + alu_b; //performs addition
            1: alu_out = alu_a * alu_b; //performs multiplication
            default: alu_out = 8'b0;
        endcase
    end

endmodule