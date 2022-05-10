
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity xaui_0_example_design is
    port (
      dclk_sf2                     : in  std_logic;
    --  reset                    : in  std_logic;
     -- xgmii_txd                : in  std_logic_vector(63 downto 0);
     -- xgmii_txc                : in  std_logic_vector(7 downto 0);
     -- xgmii_rxd                : out std_logic_vector(63 downto 0);
     -- xgmii_rxc                : out std_logic_vector(7 downto 0);
     -- clk156_out               : out std_logic;
      refclk_p                 : in  std_logic;
      refclk_n                 : in  std_logic;
     
      xaui_tx_l0_p             : out std_logic;
      xaui_tx_l0_n             : out std_logic;
      xaui_tx_l1_p             : out std_logic;
      xaui_tx_l1_n             : out std_logic;
      xaui_tx_l2_p             : out std_logic;
      xaui_tx_l2_n             : out std_logic;
      xaui_tx_l3_p             : out std_logic;
      xaui_tx_l3_n             : out std_logic;
      xaui_rx_l0_p             : in  std_logic;
      xaui_rx_l0_n             : in  std_logic;
      xaui_rx_l1_p             : in  std_logic;
      xaui_rx_l1_n             : in  std_logic;
      xaui_rx_l2_p             : in  std_logic;
      xaui_rx_l2_n             : in  std_logic;
      xaui_rx_l3_p             : in  std_logic;
      xaui_rx_l3_n             : in  std_logic
      --signal_detect            : in  std_logic_vector(3 downto 0);
      --align_status             : out std_logic;
      --sync_status              : out std_logic_vector(3 downto 0);
      --mgt_tx_ready             : out std_logic;
      --configuration_vector     : in  std_logic_vector(6 downto 0);
     -- status_vector            : out std_logic_vector(7 downto 0)
);
end xaui_0_example_design;

library ieee;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

architecture wrapper of xaui_0_example_design is

----------------------------------------------------------------------------
-- Component Declaration for the XAUI block level.
----------------------------------------------------------------------------
COMPONENT ila_1

PORT (
	clk : IN STD_LOGIC;

	probe0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
    probe1 : IN STD_LOGIC_VECTOR(5 DOWNTO 0); 
	probe2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
	probe3 : IN STD_LOGIC_VECTOR(6 DOWNTO 0); 
	probe4 : IN STD_LOGIC_VECTOR(63 DOWNTO 0); 
	probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe6 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	probe7 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		probe8 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
				probe9 : IN STD_LOGIC_VECTOR(63 DOWNTO 0)


	
	
	
	
);
END COMPONENT  ;

-----------------------------------------------------------------------------
   -- AXI
   ------------------------------------
component MY_AXI_GEN_MASTER_TOP is
port (
   m_axis_tkeep : out std_logic_vector( 7 downto 0); -- whic lane is valid
    m_axis_tvalid : out std_logic;
    m_axis_tdata : out std_logic_vector(63 downto 0); -- 4 byte
    m_axis_tready : in std_logic; -- is mac ready to receive? 
    m_axis_clk : in std_logic; 
    axi_start : in std_logic;
    axi_reset : in std_logic;
    m_axis_tlast : out std_logic 
     

);
end component;
-----------------------------------------------------------------------------
   -- 10 GEMAC
   ------------------------------------


COMPONENT ten_gig_eth_mac_0
  PORT (
   tx_clk0 : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    tx_axis_aresetn : IN STD_LOGIC;
    tx_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    tx_axis_tvalid : IN STD_LOGIC;
    tx_axis_tlast : IN STD_LOGIC;
    tx_axis_tuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    tx_ifg_delay : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    tx_axis_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    tx_axis_tready : OUT STD_LOGIC;
    tx_statistics_vector : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);
    tx_statistics_valid : OUT STD_LOGIC;
    
    rx_axis_aresetn : IN STD_LOGIC;
    rx_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    rx_axis_tvalid : OUT STD_LOGIC;
    rx_axis_tuser : OUT STD_LOGIC;
    rx_axis_tlast : OUT STD_LOGIC;
    rx_axis_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    rx_statistics_vector : OUT STD_LOGIC_VECTOR(29 DOWNTO 0);
    rx_statistics_valid : OUT STD_LOGIC;
    pause_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    pause_req : IN STD_LOGIC;
    tx_configuration_vector : IN STD_LOGIC_VECTOR(79 DOWNTO 0);
    rx_configuration_vector : IN STD_LOGIC_VECTOR(79 DOWNTO 0);
    status_vector : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    tx_dcm_locked : IN STD_LOGIC;
    
    xgmii_txd : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    xgmii_txc : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    rx_clk0 : IN STD_LOGIC;
    rx_dcm_locked : IN STD_LOGIC;
    xgmii_rxd : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    xgmii_rxc : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
   clk_wiz_50MHz_out          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;
 component xaui_0_support is
    port (
      dclk                     : in  std_logic;
      reset                    : in  std_logic;
      clk156_out               : out std_logic;
      clk156_lock              : out std_logic;
      refclk_p                 : in  std_logic;
      refclk_n                 : in  std_logic;
      refclk_out               : out std_logic;
      xgmii_txd                : in  std_logic_vector(63 downto 0);
      xgmii_txc                : in  std_logic_vector(7 downto 0);
      xgmii_rxd                : out std_logic_vector(63 downto 0);
      xgmii_rxc                : out std_logic_vector(7 downto 0);
      xaui_tx_l0_p             : out std_logic;
      xaui_tx_l0_n             : out std_logic;
      xaui_tx_l1_p             : out std_logic;
      xaui_tx_l1_n             : out std_logic;
      xaui_tx_l2_p             : out std_logic;
      xaui_tx_l2_n             : out std_logic;
      xaui_tx_l3_p             : out std_logic;
      xaui_tx_l3_n             : out std_logic;
      xaui_rx_l0_p             : in  std_logic;
      xaui_rx_l0_n             : in  std_logic;
      xaui_rx_l1_p             : in  std_logic;
      xaui_rx_l1_n             : in  std_logic;
      xaui_rx_l2_p             : in  std_logic;
      xaui_rx_l2_n             : in  std_logic;
      xaui_rx_l3_p             : in  std_logic;
      xaui_rx_l3_n             : in  std_logic;
      signal_detect            : in  std_logic_vector(3 downto 0);
      debug                    : out std_logic_vector(5 downto 0);
   -- GT Control Ports
   -- DRP
      gt0_drpaddr              : in  std_logic_vector(8 downto 0);
      gt0_drpen                : in  std_logic;
      gt0_drpdi                : in  std_logic_vector(15 downto 0);
      gt0_drpdo                : out std_logic_vector(15 downto 0);
      gt0_drprdy               : out std_logic;
      gt0_drpwe                : in  std_logic;
      gt0_drp_busy             : out std_logic;
   -- TX Reset and Initialisation
      gt0_txpmareset_in        : in std_logic;
      gt0_txpcsreset_in        : in std_logic;
      gt0_txresetdone_out      : out std_logic;
   -- RX Reset and Initialisation
      gt0_rxpmareset_in        : in std_logic;
      gt0_rxpcsreset_in        : in std_logic;
      gt0_rxpmaresetdone_out   : out std_logic;
      gt0_rxresetdone_out      : out std_logic;
   -- Clocking
      gt0_rxbufstatus_out      : out std_logic_vector(2 downto 0);
      gt0_txphaligndone_out    : out std_logic;
      gt0_txphinitdone_out     : out std_logic;
      gt0_txdlysresetdone_out  : out std_logic;
      gt_qplllock_out          : out std_logic;
   -- Signal Integrity adn Functionality
   -- Eye Scan
      gt0_eyescantrigger_in    : in  std_logic;
      gt0_eyescanreset_in      : in  std_logic;
      gt0_eyescandataerror_out : out std_logic;
      gt0_rxrate_in            : in  std_logic_vector(2 downto 0);
   -- Loopback
      gt0_loopback_in          : in  std_logic_vector(2 downto 0);
   -- Polarity
      gt0_rxpolarity_in        : in  std_logic;
      gt0_txpolarity_in        : in  std_logic;
   -- RX Decision Feedback Equalizer(DFE)
      gt0_rxlpmreset_in        : in  std_logic;
      gt0_rxlpmhfhold_in       : in  std_logic;
      gt0_rxlpmhfovrden_in     : in  std_logic;
      gt0_rxlpmlfhold_in       : in  std_logic;
      gt0_rxlpmlfovrden_in     : in  std_logic;
   -- TX Driver
      gt0_txpostcursor_in      : in std_logic_vector(4 downto 0);
      gt0_txprecursor_in       : in std_logic_vector(4 downto 0);
      gt0_txdiffctrl_in        : in std_logic_vector(3 downto 0);
      gt0_txinhibit_in         : in  std_logic;
   -- PRBS
      gt0_rxprbscntreset_in    : in  std_logic;
      gt0_rxprbserr_out        : out std_logic;
      gt0_rxprbssel_in         : in std_logic_vector(2 downto 0);
      gt0_txprbssel_in         : in std_logic_vector(2 downto 0);
      gt0_txprbsforceerr_in    : in std_logic;

      gt0_rxcdrhold_in         : in std_logic;

      gt0_dmonitorout_out      : out  std_logic_vector(14 downto 0);

   -- Status
      gt0_rxdisperr_out        : out std_logic_vector(1 downto 0);
      gt0_rxnotintable_out     : out std_logic_vector(1 downto 0);
      gt0_rxcommadet_out       : out std_logic;
   -- DRP
      gt1_drpaddr              : in  std_logic_vector(8 downto 0);
      gt1_drpen                : in  std_logic;
      gt1_drpdi                : in  std_logic_vector(15 downto 0);
      gt1_drpdo                : out std_logic_vector(15 downto 0);
      gt1_drprdy               : out std_logic;
      gt1_drpwe                : in  std_logic;
      gt1_drp_busy             : out std_logic;
   -- TX Reset and Initialisation
      gt1_txpmareset_in        : in std_logic;
      gt1_txpcsreset_in        : in std_logic;
      gt1_txresetdone_out      : out std_logic;
   -- RX Reset and Initialisation
      gt1_rxpmareset_in        : in std_logic;
      gt1_rxpcsreset_in        : in std_logic;
      gt1_rxpmaresetdone_out   : out std_logic;
      gt1_rxresetdone_out      : out std_logic;
   -- Clocking
      gt1_rxbufstatus_out      : out std_logic_vector(2 downto 0);
      gt1_txphaligndone_out    : out std_logic;
      gt1_txphinitdone_out     : out std_logic;
      gt1_txdlysresetdone_out  : out std_logic;
   -- Signal Integrity adn Functionality
   -- Eye Scan
      gt1_eyescantrigger_in    : in  std_logic;
      gt1_eyescanreset_in      : in  std_logic;
      gt1_eyescandataerror_out : out std_logic;
      gt1_rxrate_in            : in  std_logic_vector(2 downto 0);
   -- Loopback
      gt1_loopback_in          : in  std_logic_vector(2 downto 0);
   -- Polarity
      gt1_rxpolarity_in        : in  std_logic;
      gt1_txpolarity_in        : in  std_logic;
   -- RX Decision Feedback Equalizer(DFE)
      gt1_rxlpmreset_in        : in  std_logic;
      gt1_rxlpmhfhold_in       : in  std_logic;
      gt1_rxlpmhfovrden_in     : in  std_logic;
      gt1_rxlpmlfhold_in       : in  std_logic;
      gt1_rxlpmlfovrden_in     : in  std_logic;
   -- TX Driver
      gt1_txpostcursor_in      : in std_logic_vector(4 downto 0);
      gt1_txprecursor_in       : in std_logic_vector(4 downto 0);
      gt1_txdiffctrl_in        : in std_logic_vector(3 downto 0);
      gt1_txinhibit_in         : in  std_logic;
   -- PRBS
      gt1_rxprbscntreset_in    : in  std_logic;
      gt1_rxprbserr_out        : out std_logic;
      gt1_rxprbssel_in         : in std_logic_vector(2 downto 0);
      gt1_txprbssel_in         : in std_logic_vector(2 downto 0);
      gt1_txprbsforceerr_in    : in std_logic;

      gt1_rxcdrhold_in         : in std_logic;

      gt1_dmonitorout_out      : out  std_logic_vector(14 downto 0);

   -- Status
      gt1_rxdisperr_out        : out std_logic_vector(1 downto 0);
      gt1_rxnotintable_out     : out std_logic_vector(1 downto 0);
      gt1_rxcommadet_out       : out std_logic;
   -- DRP
      gt2_drpaddr              : in  std_logic_vector(8 downto 0);
      gt2_drpen                : in  std_logic;
      gt2_drpdi                : in  std_logic_vector(15 downto 0);
      gt2_drpdo                : out std_logic_vector(15 downto 0);
      gt2_drprdy               : out std_logic;
      gt2_drpwe                : in  std_logic;
      gt2_drp_busy             : out std_logic;
   -- TX Reset and Initialisation
      gt2_txpmareset_in        : in std_logic;
      gt2_txpcsreset_in        : in std_logic;
      gt2_txresetdone_out      : out std_logic;
   -- RX Reset and Initialisation
      gt2_rxpmareset_in        : in std_logic;
      gt2_rxpcsreset_in        : in std_logic;
      gt2_rxpmaresetdone_out   : out std_logic;
      gt2_rxresetdone_out      : out std_logic;
   -- Clocking
      gt2_rxbufstatus_out      : out std_logic_vector(2 downto 0);
      gt2_txphaligndone_out    : out std_logic;
      gt2_txphinitdone_out     : out std_logic;
      gt2_txdlysresetdone_out  : out std_logic;
   -- Signal Integrity adn Functionality
   -- Eye Scan
      gt2_eyescantrigger_in    : in  std_logic;
      gt2_eyescanreset_in      : in  std_logic;
      gt2_eyescandataerror_out : out std_logic;
      gt2_rxrate_in            : in  std_logic_vector(2 downto 0);
   -- Loopback
      gt2_loopback_in          : in  std_logic_vector(2 downto 0);
   -- Polarity
      gt2_rxpolarity_in        : in  std_logic;
      gt2_txpolarity_in        : in  std_logic;
   -- RX Decision Feedback Equalizer(DFE)
      gt2_rxlpmreset_in        : in  std_logic;
      gt2_rxlpmhfhold_in       : in  std_logic;
      gt2_rxlpmhfovrden_in     : in  std_logic;
      gt2_rxlpmlfhold_in       : in  std_logic;
      gt2_rxlpmlfovrden_in     : in  std_logic;
   -- TX Driver
      gt2_txpostcursor_in      : in std_logic_vector(4 downto 0);
      gt2_txprecursor_in       : in std_logic_vector(4 downto 0);
      gt2_txdiffctrl_in        : in std_logic_vector(3 downto 0);
      gt2_txinhibit_in         : in  std_logic;
   -- PRBS
      gt2_rxprbscntreset_in    : in  std_logic;
      gt2_rxprbserr_out        : out std_logic;
      gt2_rxprbssel_in         : in std_logic_vector(2 downto 0);
      gt2_txprbssel_in         : in std_logic_vector(2 downto 0);
      gt2_txprbsforceerr_in    : in std_logic;

      gt2_rxcdrhold_in         : in std_logic;

      gt2_dmonitorout_out      : out  std_logic_vector(14 downto 0);

   -- Status
      gt2_rxdisperr_out        : out std_logic_vector(1 downto 0);
      gt2_rxnotintable_out     : out std_logic_vector(1 downto 0);
      gt2_rxcommadet_out       : out std_logic;
   -- DRP
      gt3_drpaddr              : in  std_logic_vector(8 downto 0);
      gt3_drpen                : in  std_logic;
      gt3_drpdi                : in  std_logic_vector(15 downto 0);
      gt3_drpdo                : out std_logic_vector(15 downto 0);
      gt3_drprdy               : out std_logic;
      gt3_drpwe                : in  std_logic;
      gt3_drp_busy             : out std_logic;
   -- TX Reset and Initialisation
      gt3_txpmareset_in        : in std_logic;
      gt3_txpcsreset_in        : in std_logic;
      gt3_txresetdone_out      : out std_logic;
   -- RX Reset and Initialisation
      gt3_rxpmareset_in        : in std_logic;
      gt3_rxpcsreset_in        : in std_logic;
      gt3_rxpmaresetdone_out   : out std_logic;
      gt3_rxresetdone_out      : out std_logic;
   -- Clocking
      gt3_rxbufstatus_out      : out std_logic_vector(2 downto 0);
      gt3_txphaligndone_out    : out std_logic;
      gt3_txphinitdone_out     : out std_logic;
      gt3_txdlysresetdone_out  : out std_logic;
   -- Signal Integrity adn Functionality
   -- Eye Scan
      gt3_eyescantrigger_in    : in  std_logic;
      gt3_eyescanreset_in      : in  std_logic;
      gt3_eyescandataerror_out : out std_logic;
      gt3_rxrate_in            : in  std_logic_vector(2 downto 0);
   -- Loopback
      gt3_loopback_in          : in  std_logic_vector(2 downto 0);
   -- Polarity
      gt3_rxpolarity_in        : in  std_logic;
      gt3_txpolarity_in        : in  std_logic;
   -- RX Decision Feedback Equalizer(DFE)
      gt3_rxlpmreset_in        : in  std_logic;
      gt3_rxlpmhfhold_in       : in  std_logic;
      gt3_rxlpmhfovrden_in     : in  std_logic;
      gt3_rxlpmlfhold_in       : in  std_logic;
      gt3_rxlpmlfovrden_in     : in  std_logic;
   -- TX Driver
      gt3_txpostcursor_in      : in std_logic_vector(4 downto 0);
      gt3_txprecursor_in       : in std_logic_vector(4 downto 0);
      gt3_txdiffctrl_in        : in std_logic_vector(3 downto 0);
      gt3_txinhibit_in         : in  std_logic;
   -- PRBS
      gt3_rxprbscntreset_in    : in  std_logic;
      gt3_rxprbserr_out        : out std_logic;
      gt3_rxprbssel_in         : in std_logic_vector(2 downto 0);
      gt3_txprbssel_in         : in std_logic_vector(2 downto 0);
      gt3_txprbsforceerr_in    : in std_logic;

      gt3_rxcdrhold_in         : in std_logic;

      gt3_dmonitorout_out      : out  std_logic_vector(14 downto 0);

   -- Status
      gt3_rxdisperr_out        : out std_logic_vector(1 downto 0);
      gt3_rxnotintable_out     : out std_logic_vector(1 downto 0);
      gt3_rxcommadet_out       : out std_logic;
      configuration_vector     : in  std_logic_vector(6 downto 0);
      status_vector            : out std_logic_vector(7 downto 0)
);
end component;


----------------------------------------------------------------------------
-- Signal declarations.
----------------------------------------------------------------------------
signal dclk_counter : unsigned (7 downto 0) := (others =>  '0');

  SIGNAL pattern_generator_enable : STD_LOGIC := '1'; -- for enabling the pattern generator..

  SIGNAL toggle : STD_LOGIC := '0';

  SIGNAL dut_ready : STD_LOGIC := '0';
  SIGNAL enable_send_idle : unsigned (0 downto 0) := "1";
  SIGNAL configuration_vector : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
  SIGNAL status_vector_design : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
  signal   signal_detect            :   std_logic_vector(3 downto 0);
 signal align_status             :  std_logic;
 signal sync_status              :  std_logic_vector(3 downto 0);
 signal mgt_tx_ready             :  std_logic;
 --signal configuration_vector     :   std_logic_vector(6 downto 0);
  signal status_vector            :  std_logic_vector(7 downto 0);
  signal reset : std_logic := '1';
  signal clk156                : std_logic;
  signal refclk                : std_logic;
  signal dclk_i                : std_logic;
  signal debug                 : std_logic_vector(5 downto 0);

  signal xgmii_txd_pipe        : std_logic_vector(63 downto 0) := (others => '0');
  signal xgmii_txc_pipe        : std_logic_vector(7 downto 0)  := (others => '0');
  signal xgmii_rxd_pipe4       : std_logic_vector(63 downto 0) := (others => '0');
  signal xgmii_rxc_pipe4       : std_logic_vector(7 downto 0)  := (others => '0');

  signal xgmii_rxd_int         : std_logic_vector(63 downto 0) := (others => '0');
  signal xgmii_rxc_int         : std_logic_vector(7 downto 0)  := (others => '0');
  signal xgmii_txd_pipe2       : std_logic_vector(63 downto 0) := (others => '0');
  signal xgmii_txd_pipe3       : std_logic_vector(63 downto 0) := (others => '0');
  signal xgmii_txd_pipe4       : std_logic_vector(63 downto 0) := (others => '0');
  signal xgmii_txc_pipe2       : std_logic_vector(7 downto 0)  := (others => '0');
  signal xgmii_txc_pipe3       : std_logic_vector(7 downto 0)  := (others => '0');
  signal xgmii_txc_pipe4       : std_logic_vector(7 downto 0)  := (others => '0');
  signal xgmii_rxd_pipe        : std_logic_vector(63 downto 0) := (others => '0');
  signal xgmii_rxd_pipe2       : std_logic_vector(63 downto 0) := (others => '0');
  signal xgmii_rxc_pipe        : std_logic_vector(7 downto 0)  := (others => '0');
  signal xgmii_rxc_pipe2       : std_logic_vector(7 downto 0)  := (others => '0');
  signal xgmii_rxd_pipe3       : std_logic_vector(63 downto 0) := (others => '0');
  signal xgmii_rxc_pipe3       : std_logic_vector(7 downto 0)  := (others => '0');

  signal configuration_vector_pipe  : std_logic_vector(6 downto 0);
  signal configuration_vector_pipe2 : std_logic_vector(6 downto 0);
  signal configuration_vector_pipe3 : std_logic_vector(6 downto 0);
  signal signal_detect_pipe    : std_logic_vector(3 downto 0);
  signal signal_detect_pipe2   : std_logic_vector(3 downto 0);
  signal signal_detect_pipe3   : std_logic_vector(3 downto 0);
  SIGNAL counter_idle : unsigned(30 DOWNTO 0) := (others => '0'); -- counting idle frames
  SIGNAL enable_frame_send : unsigned (0 downto 0):= "1"; -- 
signal reset_cnt : unsigned (10 downto 0) := (others => '0'); -- should count reset;
--
  attribute SHREG_EXTRACT : string;

  attribute SHREG_EXTRACT of xgmii_txd_pipe : signal is "no";
  attribute SHREG_EXTRACT of xgmii_txc_pipe : signal is "no";
  attribute SHREG_EXTRACT of xgmii_rxd_pipe4 : signal is "no";
  attribute SHREG_EXTRACT of xgmii_rxc_pipe4 : signal is "no";

  attribute SHREG_EXTRACT of xgmii_txd_pipe2 : signal is "no";
  attribute SHREG_EXTRACT of xgmii_txc_pipe2 : signal is "no";
  attribute SHREG_EXTRACT of xgmii_txd_pipe3 : signal is "no";
  attribute SHREG_EXTRACT of xgmii_txc_pipe3 : signal is "no";
  attribute SHREG_EXTRACT of xgmii_txd_pipe4 : signal is "no";
  attribute SHREG_EXTRACT of xgmii_txc_pipe4 : signal is "no";
  attribute SHREG_EXTRACT of xgmii_rxd_pipe : signal is "no";
  attribute SHREG_EXTRACT of xgmii_rxc_pipe : signal is "no";
  attribute SHREG_EXTRACT of xgmii_rxd_pipe2 : signal is "no";
  attribute SHREG_EXTRACT of xgmii_rxc_pipe2 : signal is "no";
  attribute SHREG_EXTRACT of xgmii_rxd_pipe3 : signal is "no";
  attribute SHREG_EXTRACT of xgmii_rxc_pipe3 : signal is "no";

  attribute SHREG_EXTRACT of configuration_vector_pipe  : signal is "no";
  attribute SHREG_EXTRACT of configuration_vector_pipe2 : signal is "no";
  attribute SHREG_EXTRACT of configuration_vector_pipe3 : signal is "no";
  attribute SHREG_EXTRACT of signal_detect_pipe  : signal is "no";
  attribute SHREG_EXTRACT of signal_detect_pipe2 : signal is "no";
  attribute SHREG_EXTRACT of signal_detect_pipe3 : signal is "no";
 SIGNAL xgmii_txd_i : STD_LOGIC_VECTOR(63 DOWNTO 0) := X"0707070707070707";
  SIGNAL xgmii_txc_i : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"FF";
signal clk_111m111 : std_logic;
signal clk_counter : unsigned (7 downto 0) := (others => '0');
signal clk156_counter : unsigned ( 7 downto 0) := ( others => '0');
signal clk156_counter2 : unsigned ( 30 downto 0) := ( others => '0');

signal ila_idle : std_logic_vector(0 downto 0) := "0";
signal clk156_lock : std_logic := '0';
signal clk156_locked_ila : std_logic_vector (0 downto 0) := (others => '0');
  SIGNAL counter_frame_send : unsigned(6 DOWNTO 0) := "0000000"; -- counting  frames
signal refclk_out_xaui_o : std_logic;
signal xgmii_txd_mac_i : std_logic_vector( 63 downto 0) :=(others => '0') ;
signal xgmii_txc_mac_i : std_logic_vector( 7 downto 0) :=(others => '0') ;
signal clk_wiz_50Hz_o : std_logic;
---axi
    signal tx_axis_fifo_tdata           : std_logic_vector(63 downto 0);
    signal tx_axis_fifo_tkeep           : std_logic_vector(7 downto 0);
    signal tx_axis_fifo_tvalid          : std_logic;
    signal tx_axis_fifo_tlast           : std_logic;
    signal tx_axis_fifo_ready           : std_logic;
    signal aresetn : std_logic := '0';
-----------------------------

begin

clk156_locked_ila (0) <= clk156_lock;

aresetn<=not(reset);
ilacore2 : ila_1
PORT MAP (
	clk => clk_111m111,

	probe0 => std_logic_vector(dclk_counter),
	probe1 => debug, 
	probe2 => status_vector, 
	probe3 => configuration_vector, 
	probe4 => xgmii_txd_i, 
	probe5 => clk156_locked_ila, 
	probe6 => std_logic_vector(enable_frame_send),
	probe7 => std_logic_vector(enable_send_idle),
	probe8 => std_logic_vector(clk156_counter),
	probe9 => xgmii_rxd_int
	-- add some status vector..
);
 -----------------------------------------------------------------------------
   --AXI 
   ------------------------------------
  
  axi_generator : MY_AXI_GEN_MASTER_TOP
port map(
    m_axis_tkeep => tx_axis_fifo_tkeep,
    m_axis_tvalid => tx_axis_fifo_tvalid,
    m_axis_tdata => tx_axis_fifo_tdata,
    m_axis_tready => tx_axis_fifo_ready, 
    m_axis_clk  => clk156,  -- transmitter clk..
    axi_start => '1',
    axi_reset => reset,
    m_axis_tlast => tx_axis_fifo_tlast  
  ); 
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
mac1 : ten_gig_eth_mac_0
  PORT MAP (
       tx_clk0 => clk156,
    reset => reset,
    tx_axis_aresetn => aresetn, --aresetn.. is 1
    
    tx_axis_tdata => tx_axis_fifo_tdata,
    tx_axis_tvalid => tx_axis_fifo_tvalid,
    tx_axis_tlast => tx_axis_fifo_tlast,
    tx_axis_tuser => (others => '0'),
    --
    tx_ifg_delay => X"ff",
    tx_axis_tkeep => tx_axis_fifo_tkeep,
    tx_axis_tready => tx_axis_fifo_ready,
    
    tx_statistics_vector => open,
    tx_statistics_valid => open,
    
    rx_axis_aresetn => aresetn,
    
    
    rx_axis_tdata => open,
    rx_axis_tvalid => open,
    rx_axis_tuser => open,
    rx_axis_tlast => open,
    rx_axis_tkeep => open,
    rx_statistics_vector => open,
    rx_statistics_valid => open,
    pause_val => X"abcd",
    pause_req => '0',
    tx_configuration_vector => X"0605040302da00000122",-- bit 8 = 1 
    rx_configuration_vector => X"0605040302da00000022",
    status_vector => open,
    tx_dcm_locked => '1',
    
    xgmii_txd => xgmii_txd_i, --- goes to xaui input
    xgmii_txc => xgmii_txc_i,
    
    rx_clk0 => clk156,
    rx_dcm_locked => '1',
    xgmii_rxd => xgmii_txd_mac_i,
    xgmii_rxc => xgmii_txc_mac_i
  );
      ------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
--clkwiz_SF2_111_to_50MHz : clk_wiz_0
--   port map ( 
--  -- Clock out ports  
--   clk_wiz_50MHz_out => dclk_i,
--  -- Status and control signals                
--   reset => '0',
--   locked => open,
--   -- Clock in ports
--   clk_in1 => clk_111m111
-- );

    sf2_clk_buf: bufg
        port map (
            i => dclk_sf2,
            o => clk_111m111
        );

  xaui_support_i : xaui_0_support
    port map (
      dclk                      => clk_wiz_50Hz_o,
      reset                     => reset,
      clk156_out                => clk156,
      clk156_lock               => clk156_lock,
      refclk_p                  => refclk_p,
      refclk_n                  => refclk_n,
      --
      refclk_out                => refclk_out_xaui_o,
      xgmii_txd                 => xgmii_txd_i,
      xgmii_txc                 => xgmii_txc_i,
      xgmii_rxd                 => xgmii_rxd_int,
      xgmii_rxc                 => xgmii_rxc_int,
      xaui_tx_l0_p              => xaui_tx_l0_p,
      xaui_tx_l0_n              => xaui_tx_l0_n,
      xaui_tx_l1_p              => xaui_tx_l1_p,
      xaui_tx_l1_n              => xaui_tx_l1_n,
      xaui_tx_l2_p              => xaui_tx_l2_p,
      xaui_tx_l2_n              => xaui_tx_l2_n,
      xaui_tx_l3_p              => xaui_tx_l3_p,
      xaui_tx_l3_n              => xaui_tx_l3_n,
      --
      xaui_rx_l0_p              => xaui_rx_l0_p,
      xaui_rx_l0_n              => xaui_rx_l0_n,
      xaui_rx_l1_p              => xaui_rx_l1_p,
      xaui_rx_l1_n              => xaui_rx_l1_n,
      xaui_rx_l2_p              => xaui_rx_l2_p,
      xaui_rx_l2_n              => xaui_rx_l2_n,
      xaui_rx_l3_p              => xaui_rx_l3_p,
      xaui_rx_l3_n              => xaui_rx_l3_n,
      --
      signal_detect             => "1111",
      debug                     => debug,
   -- GT Control Ports
   -- DRP
       gt0_drpaddr              => (others => '0'),
       gt0_drpen                => '0',
       gt0_drpdi                => (others => '0'),
       gt0_drpdo                => open,
       gt0_drprdy               => open,
       gt0_drpwe                => '0',
       gt0_drp_busy             => open,
   -- TX Reset and Initialisation
       gt0_txpmareset_in        => '0',
       gt0_txpcsreset_in        => '0',
       gt0_txresetdone_out      => open,
   -- RX Reset and Initialisation
       gt0_rxpmareset_in        => '0',
       gt0_rxpcsreset_in        => '0',
       gt0_rxpmaresetdone_out   => open,
       gt0_rxresetdone_out      => open,
   -- Clocking
       gt0_rxbufstatus_out      => open,
       gt0_txphaligndone_out    => open,
       gt0_txphinitdone_out     => open,
       gt0_txdlysresetdone_out  => open,
       gt_qplllock_out                => open,
   -- Signal Integrity adn Functionality
   -- Eye Scan
       gt0_eyescantrigger_in    => '0',
       gt0_eyescanreset_in      => '0',
       gt0_eyescandataerror_out => open,
       gt0_rxrate_in            => "000",
   -- Loopback
       gt0_loopback_in          => "000",
   -- Polarity-------------------------------------Polarity
       gt0_rxpolarity_in        => '1',
       gt0_txpolarity_in        => '0',
   -- RX Decision Feedback Equalizer(DFE)
       gt0_rxlpmreset_in        => '0',
       gt0_rxlpmhfhold_in       => '0',
       gt0_rxlpmhfovrden_in     => '0',
       gt0_rxlpmlfhold_in       => '0',
       gt0_rxlpmlfovrden_in     => '0',
   -- TX Driver
       gt0_txdiffctrl_in        => "1000",
       gt0_txpostcursor_in      => "00000",
       gt0_txprecursor_in       => "00000",
       gt0_txinhibit_in         => '0',
   -- PRBS - GT
       gt0_rxprbscntreset_in    => '0',
       gt0_rxprbserr_out        => open,
       gt0_rxprbssel_in         => "000",
       gt0_txprbssel_in         => "000",
       gt0_txprbsforceerr_in    => '0',

       gt0_rxcdrhold_in         => '0',

       gt0_dmonitorout_out      => open,

   -- Status
       gt0_rxdisperr_out        => open,
       gt0_rxnotintable_out     => open,
       gt0_rxcommadet_out       => open,
   -- DRP
       gt1_drpaddr              => (others => '0'),
       gt1_drpen                => '0',
       gt1_drpdi                => (others => '0'),
       gt1_drpdo                => open,
       gt1_drprdy               => open,
       gt1_drpwe                => '0',
       gt1_drp_busy             => open,
   -- TX Reset and Initialisation
       gt1_txpmareset_in        => '0',
       gt1_txpcsreset_in        => '0',
       gt1_txresetdone_out      => open,
   -- RX Reset and Initialisation
       gt1_rxpmareset_in        => '0',
       gt1_rxpcsreset_in        => '0',
       gt1_rxpmaresetdone_out   => open,
       gt1_rxresetdone_out      => open,
   -- Clocking
       gt1_rxbufstatus_out      => open,
       gt1_txphaligndone_out    => open,
       gt1_txphinitdone_out     => open,
       gt1_txdlysresetdone_out  => open,
   -- Signal Integrity adn Functionality
   -- Eye Scan
       gt1_eyescantrigger_in    => '0',
       gt1_eyescanreset_in      => '0',
       gt1_eyescandataerror_out => open,
       gt1_rxrate_in            => "000",
   -- Loopback
       gt1_loopback_in          => "000",
   -- Polarity---------------------------------------Polarity
       gt1_rxpolarity_in        => '0',
       gt1_txpolarity_in        => '1',
   -- RX Decision Feedback Equalizer(DFE)
       gt1_rxlpmreset_in        => '0',
       gt1_rxlpmhfhold_in       => '0',
       gt1_rxlpmhfovrden_in     => '0',
       gt1_rxlpmlfhold_in       => '0',
       gt1_rxlpmlfovrden_in     => '0',
   -- TX Driver
       gt1_txdiffctrl_in        => "1000",
       gt1_txpostcursor_in      => "00000",
       gt1_txprecursor_in       => "00000",
       gt1_txinhibit_in         => '0',
   -- PRBS - GT
       gt1_rxprbscntreset_in    => '0',
       gt1_rxprbserr_out        => open,
       gt1_rxprbssel_in         => "000",
       gt1_txprbssel_in         => "000",
       gt1_txprbsforceerr_in    => '0',

       gt1_rxcdrhold_in         => '0',

       gt1_dmonitorout_out      => open,

   -- Status
       gt1_rxdisperr_out        => open,
       gt1_rxnotintable_out     => open,
       gt1_rxcommadet_out       => open,
   -- DRP
       gt2_drpaddr              => (others => '0'),
       gt2_drpen                => '0',
       gt2_drpdi                => (others => '0'),
       gt2_drpdo                => open,
       gt2_drprdy               => open,
       gt2_drpwe                => '0',
       gt2_drp_busy             => open,
   -- TX Reset and Initialisation
       gt2_txpmareset_in        => '0',
       gt2_txpcsreset_in        => '0',
       gt2_txresetdone_out      => open,
   -- RX Reset and Initialisation
       gt2_rxpmareset_in        => '0',
       gt2_rxpcsreset_in        => '0',
       gt2_rxpmaresetdone_out   => open,
       gt2_rxresetdone_out      => open,
   -- Clocking
       gt2_rxbufstatus_out      => open,
       gt2_txphaligndone_out    => open,
       gt2_txphinitdone_out     => open,
       gt2_txdlysresetdone_out  => open,
   -- Signal Integrity adn Functionality
   -- Eye Scan
       gt2_eyescantrigger_in    => '0',
       gt2_eyescanreset_in      => '0',
       gt2_eyescandataerror_out => open,
       gt2_rxrate_in            => "000",
   -- Loopback
       gt2_loopback_in          => "000",
   -- Polarity-------------------------------------------Polarity
       gt2_rxpolarity_in        => '0',
       gt2_txpolarity_in        => '0',
   -- RX Decision Feedback Equalizer(DFE)
       gt2_rxlpmreset_in        => '0',
       gt2_rxlpmhfhold_in       => '0',
       gt2_rxlpmhfovrden_in     => '0',
       gt2_rxlpmlfhold_in       => '0',
       gt2_rxlpmlfovrden_in     => '0',
   -- TX Driver
       gt2_txdiffctrl_in        => "1000",
       gt2_txpostcursor_in      => "00000",
       gt2_txprecursor_in       => "00000",
       gt2_txinhibit_in         => '0',
   -- PRBS - GT
       gt2_rxprbscntreset_in    => '0',
       gt2_rxprbserr_out        => open,
       gt2_rxprbssel_in         => "000",
       gt2_txprbssel_in         => "000",
       gt2_txprbsforceerr_in    => '0',

       gt2_rxcdrhold_in         => '0',

       gt2_dmonitorout_out      => open,

   -- Status
       gt2_rxdisperr_out        => open,
       gt2_rxnotintable_out     => open,
       gt2_rxcommadet_out       => open,
   -- DRP
       gt3_drpaddr              => (others => '0'),
       gt3_drpen                => '0',
       gt3_drpdi                => (others => '0'),
       gt3_drpdo                => open,
       gt3_drprdy               => open,
       gt3_drpwe                => '0',
       gt3_drp_busy             => open,
   -- TX Reset and Initialisation
       gt3_txpmareset_in        => '0',
       gt3_txpcsreset_in        => '0',
       gt3_txresetdone_out      => open,
   -- RX Reset and Initialisation
       gt3_rxpmareset_in        => '0',
       gt3_rxpcsreset_in        => '0',
       gt3_rxpmaresetdone_out   => open,
       gt3_rxresetdone_out      => open,
   -- Clocking
       gt3_rxbufstatus_out      => open,
       gt3_txphaligndone_out    => open,
       gt3_txphinitdone_out     => open,
       gt3_txdlysresetdone_out  => open,
   -- Signal Integrity adn Functionality
   -- Eye Scan
       gt3_eyescantrigger_in    => '0',
       gt3_eyescanreset_in      => '0',
       gt3_eyescandataerror_out => open,
       gt3_rxrate_in            => "000",
   -- Loopback
       gt3_loopback_in          => "000",
   -- Polarity-------------------------------------------------Polarity
       gt3_rxpolarity_in        => '0',
       gt3_txpolarity_in        => '1',
   -- RX Decision Feedback Equalizer(DFE)
       gt3_rxlpmreset_in        => '0',
       gt3_rxlpmhfhold_in       => '0',
       gt3_rxlpmhfovrden_in     => '0',
       gt3_rxlpmlfhold_in       => '0',
       gt3_rxlpmlfovrden_in     => '0',
   -- TX Driver
       gt3_txdiffctrl_in        => "1000",
       gt3_txpostcursor_in      => "00000",
       gt3_txprecursor_in       => "00000",
       gt3_txinhibit_in         => '0',
   -- PRBS - GT
       gt3_rxprbscntreset_in    => '0',
       gt3_rxprbserr_out        => open,
       gt3_rxprbssel_in         => "000",
       gt3_txprbssel_in         => "000",
       gt3_txprbsforceerr_in    => '0',

       gt3_rxcdrhold_in         => '0',

       gt3_dmonitorout_out      => open,

   -- Status
       gt3_rxdisperr_out        => open,
       gt3_rxnotintable_out     => open,
       gt3_rxcommadet_out       => open,
       --
      configuration_vector      => configuration_vector, --toggle!
      status_vector             => status_vector
);

  -- Generate DCLK
  -- This should be a stable clock to the support level. The core should be
  -- held in reset until this clock is available. For the purposes of the
  -- example design it is assumed to be a free running clock
--   dclk_bufg_i : BUFG
--     port map (
--       I => dclk,
--       O => dclk_i);

--  clk156_out_ddr : ODDR
--    port map (
--      Q  => open,-- clk156_out,
--      D1 => '0',
--      D2 => '1',
--      C  => clk156,
--      CE => '1',
--      R  => '0',
--      S  => '0');
wizclock156in50out : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_wiz_50MHz_out =>clk_wiz_50Hz_o  ,
  -- Status and control signals                
   reset =>'0',
   locked => open,
   -- Clock in ports
   clk_in1 => clk156
 );
  mgt_tx_ready <= debug(0);
  sync_status  <= debug(4 downto 1);
  align_status <= debug(5);

-- p_xgmii_tx_stimulus : PROCESS (refclk_out_xaui_o)
--  BEGIN
   
--          ---case  , und in jedem case +1
--        if rising_edge(refclk_out_xaui_o) then
--                IF counter_frame_send = 0 THEN
--                  xgmii_txd_i <= X"d5555555555555fb"; -- 7 Byte preamble 
--                  xgmii_txc_i(7 DOWNTO 0) <= X"01";
--                ELSIF counter_frame_send = 1 THEN
--                  xgmii_txd_i <= X"12DA649D99B1964A";
--                  xgmii_txc_i(7 DOWNTO 0) <= X"00";
--                ELSIF counter_frame_send = 2 THEN
--                  xgmii_txd_i <= X"55AA2E0006050403";
--                  xgmii_txc_i(7 DOWNTO 0) <= X"00";
--                ELSIF counter_frame_send >= 3 and counter_frame_send <= 7 THEN
--                  xgmii_txd_i <= X"55AA55AAAA55AA55";
--                  xgmii_txc_i(7 DOWNTO 0) <= X"00";
                
--                ELSIF counter_frame_send = 8 THEN
--                  xgmii_txd_i <= X"70CB2707AA55AA55";
--                  xgmii_txc_i(7 DOWNTO 0) <= X"00";
--                ELSIF counter_frame_send = 9 THEN
--                  --counter_frame_send <= "0000000"; --reset
--                  xgmii_txd_i(63 DOWNTO 0) <= X"07070707070707fd"; ---FRAME END
--                  xgmii_txc_i(7 DOWNTO 0) <= X"FF";
--                ELSE
--                ---  send idle...
--                      xgmii_txd_i(63 DOWNTO 0) <= X"0707070707070707"; ---FRAME END
--                      xgmii_txc_i(7 DOWNTO 0) <= X"FF";
--                END IF;
--             counter_frame_send <= counter_frame_send + 1;

--             else
--             -- noting
--             end if;
 
--  END PROCESS p_xgmii_tx_stimulus;
 ---------------------------------------------------
  -- process: Read status_vector until no faults are
  -- reported then signal the DUT is ready to the rest of the
  -- Design/Testbench.
  -- rising refclk_p
  p_config_status_vector2 : PROCESS (refclk_out_xaui_o)
  BEGIN
    IF rising_edge(refclk_out_xaui_o) THEN
   -- configuration_vector(0) <= '1';
      IF dut_ready = '0' AND status_vector_design /= "11111100" THEN
       --configuration_vector(0) <= '1'; -- set loopback
        IF toggle = '0' THEN
          configuration_vector(2) <= '1';
          configuration_vector(3) <= '1';
          toggle <= '1';
        ELSIF toggle = '1' THEN
        configuration_vector <= (others => '0');
           -- configuration_vector(2) <= '0';
          --configuration_vector(3) <= '0';
          toggle <= '0';
        END IF;
      ELSE
        dut_ready <= '1';
        

      END IF;
    END IF;
  END PROCESS p_config_status_vector2;
  
  p_reset : process ( refclk_out_xaui_o)
   begin
   if ( rising_edge(refclk_out_xaui_o) and reset = '1') then
   
     reset_cnt <= reset_cnt +1 ;
             if to_integer(reset_cnt) >= 200 then
              reset <= '0';
             else
              end if; 
      else
    end if; 
   
  end process;
   -- Synthesise input and output registers
--  p_xgmii_tx_reg : process (clk156)
--  begin
--    if rising_edge(clk156) then
--     -- xgmii_txd_pipe    <= xgmii_txd;
--     -- xgmii_txc_pipe    <= xgmii_txc;
--    end if;
--  end process p_xgmii_tx_reg;

--  p_xgmii_rx_reg : process (clk156)
--  begin
--    if rising_edge(clk156) then
--      xgmii_rxd_pipe4 <= xgmii_rxd_pipe3;
--      xgmii_rxc_pipe4 <= xgmii_rxc_pipe3;
--    end if;
--  end process p_xgmii_rx_reg;
 -- xgmii_rxd <= xgmii_rxd_pipe4;
 -- xgmii_rxc <= xgmii_rxc_pipe4;

--  -- Pipeline Registers
--  p_pipeline_tx_reg : process (clk156) begin
--    if rising_edge(clk156) then
--      xgmii_txd_pipe2 <= xgmii_txd_pipe;
--      xgmii_txd_pipe3 <= xgmii_txd_pipe2;
--      xgmii_txd_pipe4 <= xgmii_txd_pipe3;
--      xgmii_txc_pipe2 <= xgmii_txc_pipe;
--      xgmii_txc_pipe3 <= xgmii_txc_pipe2;
--      xgmii_txc_pipe4 <= xgmii_txc_pipe3;
--    end if;
--  end process;

--  p_pipeline_rx_reg : process (clk156) begin
--    if rising_edge(clk156) then
--      xgmii_rxd_pipe <= xgmii_rxd_int;
--      xgmii_rxd_pipe2 <= xgmii_rxd_pipe;
--      xgmii_rxd_pipe3 <= xgmii_rxd_pipe2;
--      xgmii_rxc_pipe <= xgmii_rxc_int;
--      xgmii_rxc_pipe2 <= xgmii_rxc_pipe;
--      xgmii_rxc_pipe3 <= xgmii_rxc_pipe2;
--    end if;
--  end process;

--  p_signal_detect_reg : process (clk156) begin
--    if rising_edge(clk156) then
--      signal_detect_pipe <= signal_detect;
--      signal_detect_pipe2 <= signal_detect_pipe;
--      signal_detect_pipe3 <= signal_detect_pipe2;
--    end if;
--  end process;

--  p_pipeline_management_reg : process (clk156) begin
--    if rising_edge(clk156) then
--      configuration_vector_pipe  <= configuration_vector;
--      configuration_vector_pipe2 <= configuration_vector_pipe;
--      configuration_vector_pipe3 <= configuration_vector_pipe2;
--    end if;
--  end process;
  
  
  
  
   p_detect_clk156 : process(clk156)
   begin
  if (rising_edge(clk156)) then
  clk156_counter <= clk156_counter +1;
  else
  end if; 
  end process;
  
  
    p_detect_dclk : process(clk_111m111)
   begin
  if (rising_edge(clk_111m111)) then
  dclk_counter <= dclk_counter +1;
  else
  end if; 
  end process;
  
  
  
  
  
  
  
  
  
  
  
  
end wrapper;
