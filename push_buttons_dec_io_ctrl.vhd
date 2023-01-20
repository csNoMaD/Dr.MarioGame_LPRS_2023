
----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2020
--
-- Input/Output controler for RGB matrix
--
-- authors:
-- Milos Subotic (milos.subotic@uns.ac.rs)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work;

entity push_buttons_dec_io_ctrl is
	port(
		iCLK       : in  std_logic;
		inRST      : in  std_logic;
		iPB_UP     : in  std_logic;
		iPB_DOWN   : in  std_logic;
		iPB_LEFT   : in  std_logic;
		iPB_RIGHT  : in  std_logic;
		iBUS_A     : in  std_logic_vector(7 downto 0);
		oBUS_RD    : out std_logic_vector(15 downto 0);
		iBUS_WD    : in  std_logic_vector(15 downto 0);
		iBUS_WE    : in  std_logic
	);
end entity push_buttons_dec_io_ctrl;

architecture Behavioral of push_buttons_dec_io_ctrl is

	type tDIR is (NONE, UP, DOWN, LEFT, RIGHT);
	signal sDIR : tDIR;
	
	signal sMOVE_X : std_logic_vector(15 downto 0);
	signal sMOVE_Y : std_logic_vector(15 downto 0);
	

begin
	
	process(iBUS_A, sMOVE_X, sMOVE_Y)
	begin
		case iBUS_A is
			when x"00" =>
				oBUS_RD <= sMOVE_X;
			when x"01" =>
				oBUS_RD <= sMOVE_Y;
			when others =>
				oBUS_RD <= (others => '0');
		end case;
	end process;
	
	process(iCLK, inRST)
	begin
		if inRST = '0' then
			sDIR <= NONE;
		elsif rising_edge(iCLK) then
			if iPB_UP = '1' then
				sDIR <= UP;
			elsif iPB_DOWN = '1' then
				sDIR <= DOWN;
			elsif iPB_LEFT = '1' then
				sDIR <= LEFT;
			elsif iPB_RIGHT = '1' then
				sDIR <= RIGHT;
			end if;
		end if;
	end process;
	
	process(sDIR)
	begin
		case sDIR is
			when NONE =>
				sMOVE_X <= conv_std_logic_vector( 0, 16);
				sMOVE_Y <= conv_std_logic_vector( 0, 16);
			when UP =>
				sMOVE_X <= conv_std_logic_vector( 0, 16);
				sMOVE_Y <= conv_std_logic_vector(-1, 16);
			when DOWN =>
				sMOVE_X <= conv_std_logic_vector( 0, 16);
				sMOVE_Y <= conv_std_logic_vector( 1, 16);
			when LEFT =>
				sMOVE_X <= conv_std_logic_vector(-1, 16);
				sMOVE_Y <= conv_std_logic_vector( 0, 16);
			when RIGHT =>
				sMOVE_X <= conv_std_logic_vector( 1, 16);
				sMOVE_Y <= conv_std_logic_vector( 0, 16);
		end case;
	end process;
	
	
end architecture;
