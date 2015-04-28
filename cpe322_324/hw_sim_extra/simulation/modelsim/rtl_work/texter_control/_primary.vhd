library verilog;
use verilog.vl_types.all;
entity texter_control is
    port(
        clk             : in     vl_logic;
        sw              : in     vl_logic;
        dash_dit        : in     vl_logic;
        dc_error        : in     vl_logic;
        space           : in     vl_logic;
        tm_reset        : out    vl_logic;
        nxt_char        : out    vl_logic;
        back_sp         : out    vl_logic;
        nxt_bit         : out    vl_logic;
        sp_load         : out    vl_logic;
        out_char        : out    vl_logic;
        out_space       : out    vl_logic
    );
end texter_control;
