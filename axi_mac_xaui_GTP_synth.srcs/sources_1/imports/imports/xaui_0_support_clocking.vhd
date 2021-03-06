-------------------------------------------------------------------------------
-- Title      : Example Design Clocking
-- Project    : XAUI
-------------------------------------------------------------------------------
-- File       : xaui_0_support_clocking.vhd
-------------------------------------------------------------------------------
-- Description: This file constains the clocking used by the example design
-------------------------------------------------------------------------------
-- (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity xaui_0_support_clocking is
    port (
      refclk_p             : in  std_logic;
      refclk_n             : in  std_logic;
      refclk               : out std_logic
      );
end xaui_0_support_clocking;

architecture rtl of xaui_0_support_clocking is

  signal refclk_p_ibuf : std_logic;
  signal refclk_n_ibuf : std_logic;
signal refclk_buff : std_logic;

signal clk_counter : unsigned (7 downto 0) := (others => '0');
signal ila_idle : std_logic_vector(0 downto 0) := "0";
------------------------
--COMPONENT ila_0

--PORT (
--	clk : IN STD_LOGIC;

--probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--	probe1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
--);
--END COMPONENT  ;

----------------
begin

refclk <= refclk_buff; 

  refclk_p_ibuf_inst : IBUF
  generic map (
    IBUF_LOW_PWR => FALSE,              -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
    IOSTANDARD   => "DEFAULT")         -- Specify the input I/O standard
  port map (
    O            => refclk_p_ibuf,     -- Buffer output
    I            => refclk_p           -- Buffer input (connect directly to top-level port)
  );
  refclk_n_ibuf_inst : IBUF
  generic map (
    IBUF_LOW_PWR => FALSE,              -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
    IOSTANDARD   => "DEFAULT")         -- Specify the input I/O standard
  port map (
    O            => refclk_n_ibuf,     -- Buffer output
    I            => refclk_n           -- Buffer input (connect directly to top-level port)
  );

  -- Differential Clock Module
    refclk_ibufds : IBUFDS_GTE2
    port map (
      I          => refclk_p_ibuf,
      IB         => refclk_n_ibuf,
      O          => refclk_buff,
      CEB        => '0',
      ODIV2      => open );
      



   p_detect_156p : process(refclk_buff)
   begin
  if (rising_edge(refclk_buff)) then
  clk_counter <= clk_counter+1;
  if (clk_counter > 10000) then
  --clk111 <= '1';
  
  else
  --clk111 <= '0';
  end if;
  else
  end if; 
  end process;


end rtl;
