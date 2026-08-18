library ieee;
use ieee.std_logic_1164.all;
 
entity full_adder is
    port (
        a  : in  std_logic;
        b  : in  std_logic;
        ci : in  std_logic;
        s  : out std_logic;
        co : out std_logic
    );
end full_adder;
 
architecture rtl of full_adder is
    signal p : std_logic;  
begin
    p  <= a xor b;
    s  <= p xor ci;
    co <= (p and ci) or ((not p) and b);
end rtl;
 

library ieee;
use ieee.std_logic_1164.all;
 
entity C4M1P3 is
    port (
        SW   : in  std_logic_vector(8 downto 0);
        LEDR : out std_logic_vector(4 downto 0)
    );
end C4M1P3;
 
architecture rtl of C4M1P3 is
 
    component full_adder
        port (
            a  : in  std_logic;
            b  : in  std_logic;
            ci : in  std_logic;
            s  : out std_logic;
            co : out std_logic
        );
    end component;
 
    signal A : std_logic_vector(3 downto 0);
    signal B : std_logic_vector(3 downto 0);
    signal S : std_logic_vector(3 downto 0);
    signal C : std_logic_vector(4 downto 0);
 
begin
 
    A    <= SW(7 downto 4);
    B    <= SW(3 downto 0);
    C(0) <= SW(8);
 
    FA0 : full_adder port map (a => A(0), b => B(0), ci => C(0), s => S(0), co => C(1));
    FA1 : full_adder port map (a => A(1), b => B(1), ci => C(1), s => S(1), co => C(2));
    FA2 : full_adder port map (a => A(2), b => B(2), ci => C(2), s => S(2), co => C(3));
    FA3 : full_adder port map (a => A(3), b => B(3), ci => C(3), s => S(3), co => C(4));
 
    LEDR(3 downto 0) <= S;
    LEDR(4)          <= C(4);
 
end rtl;