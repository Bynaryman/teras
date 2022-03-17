module dump();
    initial begin
        $dumpfile ("teras.vcd");
        $dumpvars (0, teras);
        #1;
    end
endmodule
