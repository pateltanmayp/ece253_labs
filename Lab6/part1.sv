// Finite state machine for pattern detection
`timescale 1ns / 1ns // `timescale time_unit/time_precision

// Top-level module: implements a finite state machine that detects certain patterns on the input line (w)
module part1(input logic Clock, Reset, w, output logic z, output logic [3:0] CurState);
    typedef enum logic [3:0] {A=4'd0, B=4'd1, C=4'd2, D=4'd3, E=4'd4, F=4'd5, G=4'd6} statetype;

    statetype y_Q, Y_D;

    // State table
    always_comb begin
        case (y_Q)
            A: Y_D = w ? B : A;
            B: Y_D = w ? C : A;
            C: Y_D = w ? D : E;
            D: Y_D = w ? F : E;
            E: Y_D = w ? G : A;
            F: Y_D = w ? F : E;
            G: Y_D = w ? C : A;
        endcase
    end

    // Move to next state on positive clock edge
    always_ff @(posedge Clock) begin
        if (Reset == 1'b1)
            y_Q <= A;
        else
            y_Q <= Y_D;
    end

    assign z = ((y_Q == F) | (y_Q == G));
    assign CurState = y_Q;

endmodule