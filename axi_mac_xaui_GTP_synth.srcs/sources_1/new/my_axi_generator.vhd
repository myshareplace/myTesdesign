----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/14/2022 12:38:28 PM
-- Design Name:
-- Module Name: MY_AXI_GEN_MASTER_TOP - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
------------------------------
-- AXI -Generator
------------------------------
ENTITY MY_AXI_GEN_MASTER_TOP IS
	PORT (
		m_axis_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- whic lane is valid
		m_axis_tvalid : OUT STD_LOGIC;
		m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0); -- 4 byte
		m_axis_tready : IN STD_LOGIC; -- is mac ready to receive?
		m_axis_clk : IN STD_LOGIC;
		axi_start : IN STD_LOGIC;
		axi_reset : IN STD_LOGIC;
		m_axis_tlast : OUT STD_LOGIC
	);
END MY_AXI_GEN_MASTER_TOP;

ARCHITECTURE Behavioral OF MY_AXI_GEN_MASTER_TOP IS
	----## CONSTANTS
	SIGNAL testinteger : INTEGER;
	CONSTANT NUMBER_4 : unsigned (3 DOWNTO 0) := "0100";
	CONSTANT NUMBER_3 : unsigned (3 DOWNTO 0) := "0011";
	CONSTANT NUMBER_2 : unsigned (3 DOWNTO 0) := "0010";
	CONSTANT NUMBER_1 : unsigned (3 DOWNTO 0) := "0001";
	CONSTANT NUMBER_0 : unsigned (3 DOWNTO 0) := "0000";
	CONSTANT PACKET_LEN_8 : NATURAL := 8;
	CONSTANT TESTBENCH_MODE : NATURAL := 1;
	CONSTANT PACKET_W_4 : NATURAL := 4;
	CONSTANT DEST_MAC_ADD : unsigned (47 DOWNTO 0) :=X"000000000000";-- X"DAD0D1D2D3D4";
	CONSTANT SRC_MAC_ADD : unsigned (47 DOWNTO 0) := X"5A5051525354";--X"5A5051525354";
	-- For one frame
	CONSTANT MIN_DATA_BYTES_TO_SEND : unsigned (31 DOWNTO 0) := X"0000002E"; -- 46 Bytes
	-- amount of frames in general
	CONSTANT MAX_FRAMES_TO_SEND : NATURAL := 1500;
	CONSTANT MIN_FRAMES_TO_SEND : unsigned (31 DOWNTO 0) := X"0000002e";

	--## FSM: Define the states of state machine
	TYPE state IS (IDLE, SEND_STREAM, SEND_PRE_P1, SEND_PRE_P2, SEND_AXI_DATA);
	SIGNAL current_state : state := IDLE;
	SIGNAL next_state : state := IDLE;
	--## AXI - STATUS

	SIGNAL data : unsigned(31 DOWNTO 0) := (OTHERS => '0');
	--signal tkeep : std_logic_vector(7 downto 0 ) := (others => '0');
	-- data
	SIGNAL axi_data : unsigned(63 DOWNTO 0) := (OTHERS => '0'); -- my data---
	SIGNAL axi_data_content : unsigned(63 DOWNTO 0) := (OTHERS => '0');
	--------------------------------------------
	-- COUNTER:
	----- COLUMN Counter
	SIGNAL sent_column_total_cnt : unsigned(15 DOWNTO 0) := (OTHERS => '0'); -- counts all axi columns, sums up all sent frames.
	SIGNAL sent_cur_column_cnt : unsigned(15 DOWNTO 0) := (OTHERS => '0'); -- counts sent axi columns of current frame
	signal interframe_gap_delay : unsigned (15 downto 0):= (OTHERS => '0');
	----- FRAME Counter
	SIGNAL sent_frame_cnt : unsigned (31 DOWNTO 0) := (OTHERS => '0'); --counts the sent/ axi initiated ethernet frames!
	-- single bytes for one frame
	SIGNAL total_data_bytes_for_cur_frame : unsigned(31 DOWNTO 0) := X"0000002E"; -- start with 46 each frame one byte more...
	SIGNAL left_frame_data_bytes_to_send : unsigned (31 DOWNTO 0) := X"0000002E"; -- decremnted
	SIGNAL last_status_left_frame_data : unsigned (31 DOWNTO 0); -- decremnted
	SIGNAL CRC_CHECK_ENABLE : std_logic := '1';
	signal crc_sent : std_logic := '0';
	--
	SIGNAL r_Shift1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111111";
	signal special_crc_flag : std_logic := '0';
	
	
	------------------------------
	-- BEGIN ARCHITECTURE
	------------------------------
BEGIN
	---
	-- Control state machine implementation
	-- for reset
	--FSM: AXI RESET
	SYNC_PROC : PROCESS (m_axis_clk)
	BEGIN
		IF rising_edge (m_axis_clk) THEN
			IF (axi_reset = '1') THEN
				current_state <= IDLE; -- its like reset
			ELSE
				current_state <= next_state;
			END IF;
		END IF;
	END PROCESS SYNC_PROC;

	-- connect data
	axi_data (63 DOWNTO 0) <= axi_data_content(63 DOWNTO 0); -- axi data
	m_axis_tdata <= STD_LOGIC_VECTOR(axi_data); -- data is converted to std logic vector and layed onto signal!
	------------------------------------------------
	--- FSM:
	sm_pr : PROCESS (m_axis_clk,next_state,axi_start,m_axis_tready)
	BEGIN
	
		IF (rising_edge (m_axis_clk) and m_axis_tready = '1') THEN
			CASE (next_state) IS
				---
				WHEN IDLE => -- its like reset
									 special_crc_flag <= '0';
                    interframe_gap_delay <= interframe_gap_delay +1;
                    
					axi_data_content <= (OTHERS => '0');
					m_axis_tkeep <= (OTHERS => '0'); -- no lane activated
					m_axis_tvalid <= '0'; -- nothin valid
					m_axis_tlast <= '0'; -- won't be the last
					crc_sent <= '0';
					--left_bytes_to_send <= X"0000002e";
					-- start sending .. but maybe first wait until MAC ready?
					
					IF (axi_start = '1' AND m_axis_tready = '1' AND interframe_gap_delay >= 20) THEN
						next_state <= SEND_PRE_P1;
						
						-- max_data_in_frame
						left_frame_data_bytes_to_send <= total_data_bytes_for_cur_frame;--- starts with 46 Bytes goes up to MAX
						sent_cur_column_cnt <= (OTHERS => '0'); -- reset column counter at begin of frame
                        ELSE
                        
					END IF;
					
					--########################## First fix part of preamble..
				WHEN SEND_PRE_P1 => 
					--axi status lanes
					interframe_gap_delay <= (OTHERS => '0');
					m_axis_tvalid <= '1'; -- valid data on line!
					m_axis_tlast <= '0'; -- won't be the last one!
					m_axis_tkeep <= X"FF"; -- all lanes have vaild data
					-- axi data lanes

					axi_data_content (47 DOWNTO 0) <= DEST_MAC_ADD(47 DOWNTO 0);-- 6 Bytes = 48 elements
					axi_data_content (63 DOWNTO 48) <= SRC_MAC_ADD(47 DOWNTO 32);-- 2 Bytes = 47- 32 = 16 elements

					IF (m_axis_tready = '1') -- only go to next state if MAC is ready..
				 THEN
				 next_state <= SEND_PRE_P2;
				 -- increase sent counter
				 sent_cur_column_cnt <= sent_cur_column_cnt + 1;
				 sent_column_total_cnt <= sent_column_total_cnt + 1; -- counts new sent AXI tdata columns
					 ELSE
					 
					 -- stay here
					 END IF;
					 --########################## Second fix part of preamble..TYPE-field and 2 Byte data
				 WHEN SEND_PRE_P2 => 
					 --axi status lanes
					 m_axis_tlast <= '0'; -- won't be the last one!
					 m_axis_tvalid <= '1'; -- valid data on line!
					 m_axis_tkeep <= X"FF"; -- all lanes have vaild data
					 -- axi data lanes
					 axi_data_content (31 DOWNTO 0) <= SRC_MAC_ADD(31 DOWNTO 0); -- 4 Bytes = 32 elements
					 axi_data_content (47 DOWNTO 32) <= X"0080"; -- TYPE 0x0800 Ethertype -- Attention check if its right set
					 axi_data_content (63 DOWNTO 48) <= X"0000"; -- The first axi tdata 0x0000
					 sent_column_total_cnt <= sent_column_total_cnt + 1; -- counts new sent AXI tdata columns
					 IF (m_axis_tready = '1') -- only go to next state if MAC is ready..
				 THEN
				 next_state <= SEND_AXI_DATA; -- start with stream data...
				 crc_sent <= '0';
				 -- counter
				 left_frame_data_bytes_to_send <= left_frame_data_bytes_to_send - 2; -- decrease 2 Bytes because it sent 2 Bytes DATA!
				 sent_cur_column_cnt <= sent_cur_column_cnt + 1;
				 sent_column_total_cnt <= sent_column_total_cnt + 1; -- counts new sent AXI tdata columns
					 ELSE
					 END IF;
					 --########################## Send column: with only data
					 
				 WHEN SEND_AXI_DATA => 
					 -- First check if MAC is ready to receive data
					 -- attention what should happen if m_axis is not ready?
					 -- answer: nothing
					 IF (m_axis_tready = '1') THEN

							-- Update AXI STATUS signals
							-- if less or equal 8 Bytes to send: set tlast! tlast (= indicates last message)
							-- if this is the last column of the frame set tlast!
							
							IF (left_frame_data_bytes_to_send <= 8 AND CRC_CHECK_ENABLE = '0' ) -- not if crc is there,.,,
							 THEN
							 m_axis_tlast <= '1';
							 ELSE
							  m_axis_tlast <= '0';
							 END IF;
							 --- AXI-DATA:
							 --- Put new data onto lines: l7 ... l0
							 axi_data_content(15 DOWNTO 0) <= resize(((sent_cur_column_cnt - X"2") * NUMBER_4 + NUMBER_0 + 1), 16);
							 axi_data_content(31 DOWNTO 16) <= resize(((sent_cur_column_cnt - X"2") * NUMBER_4 + NUMBER_1 + 1), 16);
							 axi_data_content(47 DOWNTO 32) <= resize(((sent_cur_column_cnt - X"2") * NUMBER_4 + NUMBER_2 + 1), 16);
							 axi_data_content(63 DOWNTO 48) <= resize(((sent_cur_column_cnt - X"2") * NUMBER_4 + NUMBER_3 + 1), 16);
							 --- append crc

							 ---

							 -- * tvalid (= are there valid data)
							 -- is still 1 from previous state
							 -- when leaving this state it will be reset

							 -- * tkeep (= shows which line is valid)
							 -- shift a 8 Bit 1 vector with amount of left bytes for this string
							 --

							 IF (left_frame_data_bytes_to_send(31 DOWNTO 0) >= 8)
							 THEN
							 m_axis_tkeep <= X"FF";

							 ELSE
								 ---e.g. only 5 Bytes to send: shift right(0x11111111) by 8-4 = 4 >>>> 0x00001111
								 -- ??????????? please check again is simualtion
								 m_axis_tkeep <= STD_LOGIC_VECTOR(shift_right(unsigned (r_Shift1), 8 - to_integer(left_frame_data_bytes_to_send)));
								 IF CRC_CHECK_ENABLE = '1' THEN
										last_status_left_frame_data <= left_frame_data_bytes_to_send;
										--------------------------------------------------- append crc
										CASE (to_integer(left_frame_data_bytes_to_send)) IS
											WHEN 7 => 
												axi_data_content(63 DOWNTO 56) <= X"CD";---
											     m_axis_tkeep <= X"FF";
											     m_axis_tlast <= '0'; -- because @ next  column soemthing is coming
											     

											WHEN 6 => 
												axi_data_content(63 DOWNTO 48) <= X"ABCD";---
                                            m_axis_tkeep <= X"FF";
                                            m_axis_tlast <= '0';-- because @ next  column soemthing is coming
											WHEN 5 => 
												axi_data_content(63 DOWNTO 40) <= X"CDABCD";---
												m_axis_tkeep <= X"FF";
												m_axis_tlast <= '0'; -- because @ next  column soemthing is coming
												------------ 
											WHEN 4 => 
												axi_data_content(63 DOWNTO 32) <= X"ABCDABCD";
												m_axis_tkeep <= X"FF";
												m_axis_tlast <= '1';
												crc_sent<= '1'; 
												----------------- special_crc_flag
												special_crc_flag <= '1';
											WHEN 3 => 
												axi_data_content(55 DOWNTO 24) <= X"ABCDABCD";
											 m_axis_tkeep <= X"7F";
											 m_axis_tlast <= '1';
											 crc_sent<= '1';
											WHEN 2 => 
												axi_data_content(47 DOWNTO 16) <= X"ABCDABCD";
											     m_axis_tkeep <= X"3F";
											m_axis_tlast <= '1';
											crc_sent<= '1';
											WHEN 1 => 
												axi_data_content(39 DOWNTO 8) <= X"ABCDABCD";
												m_axis_tkeep <= X"1F";
												m_axis_tlast <= '1';
												crc_sent<= '1';
											WHEN OTHERS => 
										END CASE;
										
										
										IF to_integer(left_frame_data_bytes_to_send) = 0 THEN
										 m_axis_tlast <= '1';
											axi_data_content <= (OTHERS => '0');
 
											CASE (to_integer(last_status_left_frame_data)) IS -- attention 
												WHEN 5 => 
													axi_data_content(7 DOWNTO 0) <= X"AB";
													m_axis_tlast <= '1';
													m_axis_tkeep <= X"01";
													crc_sent<= '1';
 
												WHEN 6 => 
 
													axi_data_content(15 DOWNTO 0) <= X"ABCD";
													m_axis_tlast <= '1';
													m_axis_tkeep <= X"03";
													crc_sent<= '1';
												WHEN 7 => 
													axi_data_content(23 DOWNTO 0) <= X"ABCDAB";
													m_axis_tlast <= '1';
													m_axis_tkeep <= X"07";
													crc_sent<= '1';
												WHEN OTHERS => 
											END CASE;
 
										ELSE -- not 0
										END IF;
									ELSE -- no crc
									END IF; -- crc
								END IF;

								-- Decrease the amount of bytes put on the lane: The left frame bytes which are to send. but if overflow would occur : set it to 0 -- is the same
								-- algorithm should be better
								-- checks if less than 0 (by overflow because its unsigned..) 400000 is just a high value
								IF left_frame_data_bytes_to_send - X"8" > 40000 THEN
									left_frame_data_bytes_to_send <= (OTHERS => '0'); --correct overflow to 0
								ELSIF left_frame_data_bytes_to_send - X"8" >= 0 THEN --- if now 8 Bytes are send
									left_frame_data_bytes_to_send <= left_frame_data_bytes_to_send - X"8"; -- decrease those 8 Bytes
								ELSE
									left_frame_data_bytes_to_send <= left_frame_data_bytes_to_send - X"1"; ---- If not all lanes are used dont decrease so much

								END IF;

								-- ##########################################Check if FRAME is finished:

								----- left frames bytes : should be between 0 and total_data_bytes_for_cur_frame
								----- if 8 left it means already 0...
								
								
								IF (to_integer(left_frame_data_bytes_to_send) > 0 AND to_integer(left_frame_data_bytes_to_send) < to_integer( total_data_bytes_for_cur_frame)) -- only go to next state if MAC is ready..
								 THEN
								 ---* Send Next Byte if ready

								 next_state <= SEND_AXI_DATA; -- if frames are still left go again, stay in same state.
								 -- counter
								 sent_cur_column_cnt <= sent_cur_column_cnt + 1; -- can be done somewhere else..
								 sent_column_total_cnt <= sent_column_total_cnt + 1; -- can be done somewhere else counts new sent AXI tdata columns
                                    
                               else 
                               end if;
                              
--                               if crc_sent = '1' and to_integer (left_frame_data_bytes_to_send) < 8 then
--                               		next_state <= IDLE; -- ...or go to send pre_
--                                    sent_frame_cnt <= sent_frame_cnt + 1; -- increment because this means end of frame!
--									sent_cur_column_cnt <= sent_cur_column_cnt + 1;
--									sent_column_total_cnt <= sent_column_total_cnt + 1; 
									
									 
--                               end if;
                               
                                if to_integer(left_frame_data_bytes_to_send) = 4 then
									                                   
									 -- Counter
									 sent_frame_cnt <= sent_frame_cnt + 1; -- increment because this means end of frame!
									 sent_cur_column_cnt <= sent_cur_column_cnt + 1;
									 sent_column_total_cnt <= sent_column_total_cnt + 1; -- counts new sent AXI tdata columns
									 -- state:
									  m_axis_tlast <= '1';
									 next_state <= IDLE; -- ...or go to send pre_
									 IF to_integer(sent_frame_cnt) < MAX_FRAMES_TO_SEND THEN
											-- if not sent all:
											sent_frame_cnt <= sent_frame_cnt + 1; -- increment frame counter
											total_data_bytes_for_cur_frame <= total_data_bytes_for_cur_frame + 1; -- add one for the amount bytes for the next frame
										ELSE
											-- if sent all e.g. 1500 Frames:
											-- resetframe counter
											-- or put it in idle
											sent_frame_cnt <= X"00000000";--RESET counter of sent frames
											total_data_bytes_for_cur_frame <= MIN_FRAMES_TO_SEND;--starts with minum X"0000002E";

										END IF;
									 end if;
									 
							            if to_integer(left_frame_data_bytes_to_send) < 8  then
									                                   
									 -- Counter
									 sent_frame_cnt <= sent_frame_cnt + 1; -- increment because this means end of frame!
									 sent_cur_column_cnt <= sent_cur_column_cnt + 1;
									 sent_column_total_cnt <= sent_column_total_cnt + 1; -- counts new sent AXI tdata columns
									 -- state:
									  m_axis_tlast <= '1';
									 next_state <= IDLE; -- ...or go to send pre_
									 IF to_integer(sent_frame_cnt) < MAX_FRAMES_TO_SEND THEN
											-- if not sent all:
											sent_frame_cnt <= sent_frame_cnt + 1; -- increment frame counter
											total_data_bytes_for_cur_frame <= total_data_bytes_for_cur_frame + 1; -- add one for the amount bytes for the next frame
										ELSE
											-- if sent all e.g. 1500 Frames:
											-- resetframe counter
											-- or put it in idle
											sent_frame_cnt <= X"00000000";--RESET counter of sent frames
											total_data_bytes_for_cur_frame <= MIN_FRAMES_TO_SEND;--starts with minum X"0000002E";

										END IF;
									 end if;		 
									 
									 
									 
									 
									 
								 if to_integer(left_frame_data_bytes_to_send) = 0 then
									                                   
									 -- Counter
									 sent_frame_cnt <= sent_frame_cnt + 1; -- increment because this means end of frame!
									 sent_cur_column_cnt <= sent_cur_column_cnt + 1;
									 sent_column_total_cnt <= sent_column_total_cnt + 1; -- counts new sent AXI tdata columns
									 -- state:
									 next_state <= IDLE; -- ...or go to send pre_
                                     m_axis_tlast <= '1';
									 ---Check if ALL e.g. 1500 frames sent already!

									 IF to_integer(sent_frame_cnt) < MAX_FRAMES_TO_SEND THEN
											-- if not sent all:
											sent_frame_cnt <= sent_frame_cnt + 1; -- increment frame counter
											total_data_bytes_for_cur_frame <= total_data_bytes_for_cur_frame + 1; -- add one for the amount bytes for the next frame
										ELSE
											-- if sent all e.g. 1500 Frames:
											-- resetframe counter
											-- or put it in idle
											sent_frame_cnt <= X"00000000";--RESET counter of sent frames
											total_data_bytes_for_cur_frame <= MIN_FRAMES_TO_SEND;--starts with minum X"0000002E";

										END IF;
									END IF;
								ELSE
									-- do nothing..until reset or tready comes..
								END IF;

				WHEN OTHERS => 
									next_state <= IDLE;
							END CASE;
						END IF;
					END PROCESS sm_pr;
END Behavioral;