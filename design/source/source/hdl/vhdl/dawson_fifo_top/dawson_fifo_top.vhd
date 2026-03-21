library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dawson_fifo_top is
    generic(
        width : integer := 8;
        depth : integer := 1024;
        TDATA_ERROR_VALUE : integer := 1
    );
    port(
        s_axis_aclk : in std_logic;
        s_axis_aresetn : in std_logic;
        s_axis_tdata : in std_logic_vector(width-1 downto 0);
        s_axis_tvalid : in std_logic;
        s_axis_tready : out std_logic;
        m_axis_tdata : out std_logic_vector(width-1 downto 0);
        m_axis_tvalid : out std_logic;
        m_axis_tready : in std_logic;
        induce_error_tdata : in std_logic := '0';
        nearly_full : out std_logic;
        nearly_empty : out std_logic
    );
end entity dawson_fifo_top;

architecture rtl of dawson_fifo_top is

    signal m_axis_tdata_fifo : std_logic_vector(width-1 downto 0) := (others => '0');
    signal simple_nyquist_frequency_count : std_logic := '0';
    signal simple_nyquist_frequency_tdata : std_logic_vector(width-1 downto 0) := (others => '0');
    constant m_axis_tdata_max_positive_number : std_logic_vector(width-1 downto 0) := ((m_axis_tdata_fifo'length)-1 => '0', others => '1');
    constant m_axis_tdata_max_negative_number : std_logic_vector(width-1 downto 0) := ((m_axis_tdata_fifo'length)-1 => '1', others => '0');

    
begin

    axis_fifo : entity work.dawson_fifo(rtl)
    generic map(
        width => width,                -- width : integer := 8;
        depth => depth                 -- depth : integer := 1024
    )
    port map(
        clk => s_axis_aclk,            -- clk : in std_logic;
        rst => not s_axis_aresetn,     -- rst : in std_logic;
        input => s_axis_tdata,         -- input : in std_logic_vector(width-1 downto 0);
        input_valid => s_axis_tvalid,  -- input_valid : in std_logic;
        input_ready => s_axis_tready,  -- input_ready : out std_logic;
        output => m_axis_tdata_fifo,   -- output : out std_logic_vector(width-1 downto 0);
        output_valid => m_axis_tvalid, -- output_valid : out std_logic;
        output_ready => m_axis_tready, -- output_ready : in std_logic;
        nearly_full => nearly_full,    -- nearly_full : out std_logic;
        nearly_empty => nearly_empty   -- nearly_empty : out std_logic
    );

process(s_axis_aclk)
begin
    if rising_edge(s_axis_aclk) then
        if not s_axis_aresetn then
            simple_nyquist_frequency_count <= '0';
        elsif m_axis_tvalid and m_axis_tready then 
            simple_nyquist_frequency_count <= not simple_nyquist_frequency_count;
        end if;
    end if;
end process;

--constant m_axis_tdata_max_positive_number : std_logic_vector(width-1 downto 0) := ((m_axis_tdata_fifo'length)-1 => '1', others => '0');
--constant m_axis_tdata_max_negative_number : std_logic_vector(width-1 downto 0) := (others => '1');

process(all)
begin
    simple_nyquist_frequency_tdata <= m_axis_tdata_max_positive_number when simple_nyquist_frequency_count else m_axis_tdata_max_negative_number;
end process;  

process(all)
begin
    --m_axis_tdata <= induce_error_tdata xor m_axis_tdata_fifo; -- Invert all bits when induce error input is high to create an error'd ouput of tdata
    --m_axis_tdata <= TDATA_ERROR_VALUE when induce_error_tdata else m_axis_tdata_fifo; -- Set tdata to a constant when induce error input is high to create an error'd ouput of tdata
    --m_axis_tdata <= std_logic_vector(to_unsigned(TDATA_ERROR_VALUE, m_axis_tdata_fifo'length)) when induce_error_tdata else m_axis_tdata_fifo; -- Set tdata to a constant when induce error input is high to create an error'd ouput of tdata
    m_axis_tdata <= simple_nyquist_frequency_tdata when induce_error_tdata else m_axis_tdata_fifo; -- Set tdata to a constant when induce error input is high to create an error'd ouput of tdata
end process;  
    
    
end rtl;