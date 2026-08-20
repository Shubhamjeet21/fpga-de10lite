library ieee;
use ieee.std_logic_1164.all;
 
-- ---------------------------------------------------------------------
-- One-bit full adder (Part III)
-- ---------------------------------------------------------------------
entity full_adder is
    port ( a, b, ci : in  std_logic;
           s, co    : out std_logic );
end full_adder;
 
architecture dataflow of full_adder is
    signal p : std_logic;
begin
    p  <= a xor b;
    s  <= p xor ci;
    co <= (p and ci) or ((not p) and b);
end dataflow;
 
-- ---------------------------------------------------------------------
-- Four-bit ripple carry adder (Part III)
-- ---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity adder4 is
    port ( A, B : in  std_logic_vector(3 downto 0);
           ci   : in  std_logic;
           S    : out std_logic_vector(3 downto 0);
           co   : out std_logic );
end adder4;
 
architecture structural of adder4 is
    component full_adder is
        port ( a, b, ci : in std_logic; s, co : out std_logic );
    end component;
    signal c : std_logic_vector(4 downto 0);
begin
    c(0) <= ci;
    stage : for i in 0 to 3 generate
        FA : full_adder port map (a => A(i), b => B(i), ci => c(i),
                                  s => S(i), co => c(i+1));
    end generate;
    co <= c(4);
end structural;
 
-- ---------------------------------------------------------------------
-- Binary (0..15) to two decimal digits (Part II)
-- ---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity bin2dec is
    port ( V  : in  std_logic_vector(3 downto 0);
           d1 : out std_logic;                       -- tens: 0 or 1
           d0 : out std_logic_vector(3 downto 0) );  -- units
end bin2dec;
 
architecture dataflow of bin2dec is
    signal z  : std_logic;                      -- '1' when V > 9
    signal zv : std_logic_vector(3 downto 0);
    signal A  : std_logic_vector(3 downto 0);   -- V - 10
begin
    z  <= V(3) and (V(2) or V(1));
    zv <= (others => z);
 
    A(3) <= '0';
    A(2) <= V(2) and V(1);
    A(1) <= V(2) and (not V(1));
    A(0) <= V(0);
 
    d0 <= (A and zv) or (V and (not zv));       -- 4-bit 2-to-1 mux
    d1 <= z;
end dataflow;
 
-- ---------------------------------------------------------------------
-- BCD to seven segment, active low (Part I)
-- ---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity hex7seg is
    port ( C : in  std_logic_vector(3 downto 0);
           H : out std_logic_vector(6 downto 0) );
end hex7seg;
 
architecture dataflow of hex7seg is
    -- VHDL identifiers are case insensitive, so a signal named c would
    -- clash with the port C. Prefix every segment signal to keep them apart.
    signal sa, sb, sc, sd, se, sf, sg : std_logic;
begin
    sa <= C(3) or C(1) or (C(2) and C(0)) or ((not C(2)) and (not C(0)));
    sb <= (not C(2)) or (C(1) and C(0)) or ((not C(1)) and (not C(0)));
    sc <= C(2) or (not C(1)) or C(0);
    sd <= C(3) or ((not C(2)) and (not C(0))) or ((not C(2)) and C(1))
               or (C(1) and (not C(0))) or (C(2) and (not C(1)) and C(0));
    se <= ((not C(2)) and (not C(0))) or (C(1) and (not C(0)));
    sf <= C(3) or (C(2) and (not C(1))) or (C(2) and (not C(0)))
               or ((not C(1)) and (not C(0)));
    sg <= C(3) or (C(2) and (not C(1))) or ((not C(2)) and C(1))
               or (C(1) and (not C(0)));
 
    H(0) <= not sa;
    H(1) <= not sb;
    H(2) <= not sc;
    H(3) <= not sd;
    H(4) <= not se;
    H(5) <= not sf;
    H(6) <= not sg;
end dataflow;
 
-- ---------------------------------------------------------------------
-- Top level : BCD adder
-- ---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity C4M1P4 is
    port ( SW   : in  std_logic_vector(8 downto 0);
           LEDR : out std_logic_vector(9 downto 0);
           HEX0 : out std_logic_vector(6 downto 0);
           HEX1 : out std_logic_vector(6 downto 0) );
end C4M1P4;
 
architecture structural of C4M1P4 is
 
    component adder4 is
        port ( A, B : in  std_logic_vector(3 downto 0);
               ci   : in  std_logic;
               S    : out std_logic_vector(3 downto 0);
               co   : out std_logic );
    end component;
 
    component bin2dec is
        port ( V  : in  std_logic_vector(3 downto 0);
               d1 : out std_logic;
               d0 : out std_logic_vector(3 downto 0) );
    end component;
 
    component hex7seg is
        port ( C : in  std_logic_vector(3 downto 0);
               H : out std_logic_vector(6 downto 0) );
    end component;
 
    signal X, Y   : std_logic_vector(3 downto 0);
    signal cin    : std_logic;
    signal T      : std_logic_vector(3 downto 0);  -- low four bits of X+Y+cin
    signal c4     : std_logic;                     -- carry out, weight 16
    signal c4v    : std_logic_vector(3 downto 0);
    signal d1     : std_logic;                     -- tens from bin2dec
    signal d0     : std_logic_vector(3 downto 0);  -- units from bin2dec
    signal Acorr  : std_logic_vector(3 downto 0);  -- T + 6, used only when c4='1'
    signal S0, S1 : std_logic_vector(3 downto 0);
    signal invalid: std_logic;
 
begin
 
    X   <= SW(7 downto 4);
    Y   <= SW(3 downto 0);
    cin <= SW(8);
 
    -- Raw five-bit sum: c4 & T, range 0 .. 19
    U0 : adder4   port map (A => X, B => Y, ci => cin, S => T, co => c4);
 
    -- Decimal conversion of the low four bits (valid on its own when c4 = '0')
    U1 : bin2dec  port map (V => T, d1 => d1, d0 => d0);
 
    -- Correction path. c4 = '1' means the true value is 16 + T with T in 0..3,
    -- i.e. 16..19, so the units digit is T + 6 and the tens digit is 1.
    --   T = 00 -> 0110 (6)   T = 10 -> 1000 (8)
    --   T = 01 -> 0111 (7)   T = 11 -> 1001 (9)
    Acorr(3) <= T(1);
    Acorr(2) <= not T(1);
    Acorr(1) <= not T(1);
    Acorr(0) <= T(0);
 
    c4v <= (others => c4);
 
    -- Units digit: c4 selects the corrected value over the Part II result
    S0 <= (Acorr and c4v) or (d0 and (not c4v));
 
    -- Tens digit. When c4 = '1', T <= 3 so bin2dec drives d1 = '0';
    -- the OR therefore needs no multiplexer.
    S1(3) <= '0';
    S1(2) <= '0';
    S1(1) <= '0';
    S1(0) <= c4 or d1;
 
    U2 : hex7seg port map (C => S0, H => HEX0);
    U3 : hex7seg port map (C => S1, H => HEX1);
 
    -- Illegal BCD input: value greater than nine on either digit
    invalid <= (X(3) and (X(2) or X(1))) or (Y(3) and (Y(2) or Y(1)));
 
    LEDR(9)          <= invalid;
    LEDR(8 downto 0) <= (others => '0');
 
end structural;