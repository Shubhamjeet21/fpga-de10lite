library ieee;
use ieee.std_logic_1164.all;

entity hex7seg is
    port (
        bin : in  std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0)
    );
end entity hex7seg;

architecture boolean_eqns of hex7seg is
    signal b3, b2, b1, b0 : std_logic;
    signal sa, sb, sc, sd : std_logic;
    signal se, sf, sg     : std_logic;
begin

    b3 <= bin(3);
    b2 <= bin(2);
    b1 <= bin(1);
    b0 <= bin(0);

    sa <= b3 or b1 or (b2 and b0) or ((not b2) and (not b0));
    sb <= (not b2) or ((not b1) and (not b0)) or (b1 and b0);
    sc <= b2 or (not b1) or b0;
    sd <= b3 or ((not b2) and (not b0)) or (b1 and (not b0))
             or ((not b2) and b1) or (b2 and (not b1) and b0);
    se <= ((not b2) and (not b0)) or (b1 and (not b0));
    sf <= b3 or (b2 and (not b1)) or (b2 and (not b0))
             or ((not b1) and (not b0));
    sg <= b3 or (b2 and (not b1)) or ((not b2) and b1) or (b1 and (not b0));

    seg(0) <= not sa;
    seg(1) <= not sb;
    seg(2) <= not sc;
    seg(3) <= not sd;
    seg(4) <= not se;
    seg(5) <= not sf;
    seg(6) <= not sg;

end architecture boolean_eqns;


library ieee;
use ieee.std_logic_1164.all;

entity C4M1P2 is
    port (
        SW   : in  std_logic_vector(3 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
        HEX1 : out std_logic_vector(6 downto 0)
    );
end entity C4M1P2;

architecture boolean_eqns of C4M1P2 is

    signal V  : std_logic_vector(3 downto 0);
    signal A  : std_logic_vector(3 downto 0);
    signal D0 : std_logic_vector(3 downto 0);
    signal D1 : std_logic_vector(3 downto 0);
    signal z  : std_logic;
    signal zv : std_logic_vector(3 downto 0);

begin

    V <= SW;

    z <= V(3) and (V(2) or V(1));

    A(3) <= '0';
    A(2) <= V(2) and V(1);
    A(1) <= V(2) and (not V(1));
    A(0) <= V(0);

    zv <= (others => z);
    D0 <= (V and (not zv)) or (A and zv);

    D1(3) <= '0';
    D1(2) <= '0';
    D1(1) <= '0';
    D1(0) <= z;

    u_hex0 : entity work.hex7seg port map (bin => D0, seg => HEX0);
    u_hex1 : entity work.hex7seg port map (bin => D1, seg => HEX1);

end architecture boolean_eqns;