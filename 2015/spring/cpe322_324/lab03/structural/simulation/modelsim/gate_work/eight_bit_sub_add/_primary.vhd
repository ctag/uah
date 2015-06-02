library verilog;
use verilog.vl_types.all;
entity eight_bit_sub_add is
    port(
        D_S             : out    vl_logic_vector(7 downto 0);
        B_COUT          : out    vl_logic;
        A               : in     vl_logic_vector(7 downto 0);
        B               : in     vl_logic_vector(7 downto 0);
        B_CIN           : in     vl_logic;
        SUB_ADD         : in     vl_logic
    );
end eight_bit_sub_add;
