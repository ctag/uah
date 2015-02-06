library verilog;
use verilog.vl_types.all;
entity four_bit_sub_add is
    port(
        d_s             : out    vl_logic_vector(3 downto 0);
        b_cout          : out    vl_logic;
        a               : in     vl_logic_vector(3 downto 0);
        b               : in     vl_logic_vector(3 downto 0);
        b_cin           : in     vl_logic;
        sub_add         : in     vl_logic
    );
end four_bit_sub_add;
