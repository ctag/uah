library verilog;
use verilog.vl_types.all;
entity fullsubadd is
    port(
        dif_sum         : out    vl_logic;
        b_cout          : out    vl_logic;
        x               : in     vl_logic;
        y               : in     vl_logic;
        b_cin           : in     vl_logic;
        sub_add         : in     vl_logic
    );
end fullsubadd;
