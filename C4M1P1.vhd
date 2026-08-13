library ieee;
use ieee.std_logic_1164.all;
 
entity C4M1P1 is
    port (
        SW   : in  std_logic_vector(9 downto 0);
        HEX0 : out std_logic_vector(7 downto 0);
        HEX1 : out std_logic_vector(7 downto 0)
    );
end C4M1P1;
 
 
architecture Boolean_Equations of C4M1P1 is
 
    -- Input bits of the low-order digit (SW3-0)
    signal L3, L2, L1, L0 : std_logic;
 
    -- Input bits of the high-order digit (SW7-4)
    signal H3, H2, H1, H0 : std_logic;
 
    -- Segment drive signals, active high (1 = lit)
    signal La, Lb, Lc, Ld, Le, Lf, Lg : std_logic;
    signal Ha, Hb, Hc, Hd, He, Hf, Hg : std_logic;
 
begin
 
    -- Split the switch inputs into two 4-bit digits
    
    L3 <= SW(3);
    L2 <= SW(2);
    L1 <= SW(1);
    L0 <= SW(0);
 
    H3 <= SW(7);
    H2 <= SW(6);
    H1 <= SW(5);
    H0 <= SW(4);
 
 
   
    -- Low-order digit : Boolean expression for each segment
   
    La <= L3 or L1 or (L2 and L0) or ((not L2) and (not L0));
 
    Lb <= (not L2) or (L1 and L0) or ((not L1) and (not L0));
 
    Lc <= L2 or (not L1) or L0;
 
    Ld <= L3
          or ((not L2) and (not L0))
          or ((not L2) and L1)
          or (L1 and (not L0))
          or (L2 and (not L1) and L0);
 
    Le <= ((not L2) and (not L0)) or (L1 and (not L0));
 
    Lf <= L3
          or (L2 and (not L1))
          or (L2 and (not L0))
          or ((not L1) and (not L0));
 
    Lg <= L3
          or (L2 and (not L1))
          or ((not L2) and L1)
          or (L1 and (not L0));
 
 
    -- High-order digit : identical expressions on the H inputs
 
    Ha <= H3 or H1 or (H2 and H0) or ((not H2) and (not H0));
 
    Hb <= (not H2) or (H1 and H0) or ((not H1) and (not H0));
 
    Hc <= H2 or (not H1) or H0;
 
    Hd <= H3
          or ((not H2) and (not H0))
          or ((not H2) and H1)
          or (H1 and (not H0))
          or (H2 and (not H1) and H0);
 
    He <= ((not H2) and (not H0)) or (H1 and (not H0));
 
    Hf <= H3
          or (H2 and (not H1))
          or (H2 and (not H0))
          or ((not H1) and (not H0));
 
    Hg <= H3
          or (H2 and (not H1))
          or ((not H2) and H1)
          or (H1 and (not H0));
 
 
    -- Drive the displays.  Segments are active low, so invert.
 
    HEX0(0) <= not La;
    HEX0(1) <= not Lb;
    HEX0(2) <= not Lc;
    HEX0(3) <= not Ld;
    HEX0(4) <= not Le;
    HEX0(5) <= not Lf;
    HEX0(6) <= not Lg;
    HEX0(7) <= '1';            -- decimal point off
 
    HEX1(0) <= not Ha;
    HEX1(1) <= not Hb;
    HEX1(2) <= not Hc;
    HEX1(3) <= not Hd;
    HEX1(4) <= not He;
    HEX1(5) <= not Hf;
    HEX1(6) <= not Hg;
    HEX1(7) <= '1';            -- decimal point off
 
end Boolean_Equations;