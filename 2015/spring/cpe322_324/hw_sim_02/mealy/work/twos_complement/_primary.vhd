library verilog;
use verilog.vl_types.all;
entity twos_complement is
    generic(
        S0              : integer := 0;
        S1              : integer := 1;
        S2              : integer := 2
    );
    port(
        Bin             : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        Bout            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of S0 : constant is 1;
    attribute mti_svvh_generic_type of S1 : constant is 1;
    attribute mti_svvh_generic_type of S2 : constant is 1;
end twos_complement;
