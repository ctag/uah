library verilog;
use verilog.vl_types.all;
entity DS1620_INTERFACE is
    port(
        CLR             : in     vl_logic;
        CLK_IN          : in     vl_logic;
        TEMP            : out    vl_logic_vector(8 downto 0);
        CLK_OUT         : out    vl_logic;
        RST             : out    vl_logic;
        TRI_EN          : out    vl_logic;
        DQ_IN           : in     vl_logic;
        DQ_OUT          : out    vl_logic
    );
end DS1620_INTERFACE;
