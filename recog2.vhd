LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY recog2 IS
port (
      X: in	bit;
      CLK: in	bit;
      RESET: in	bit;
      Y: out		bit);
end;

ARCHITECTURE myArch OF recog2 IS
  --state declaration
  TYPE state_type IS (INIT, FIRST, SECOND, THIRD) ; 	
    SIGNAL curState, nextState: state_type;
    SIGNAL reset0, enable0, reset1, enable1: STD_LOGIC;
    SIGNAL count0, count1: integer;
  BEGIN
     combi_nextState: PROCESS(curState, x)
  BEGIN
    CASE curState IS
      WHEN INIT =>
          reset1 <= '1';
          enable1 <= '0';
        IF x='0' THEN 
          reset0 <= '0';
          enable0 <= '1';
          nextState <= FIRST;
        ELSE
            IF x='1' THEN
            reset0 <= '1' ;
            enable0 <= '0' ;
            nextState <= curState;
        END IF;
      END IF;
        
      WHEN FIRST =>
        IF Count0 = 15 THEN
          reset0 <= '1' ;
          enable0 <= '0' ; 
          enable1 <= '1' ;      
          nextState <= SECOND; 
        ELSE IF Count0 /= 15 AND x ='1' THEN
            reset0 <='1';
            enable0 <= '0';
            nextState <= INIT;
       ELSE IF Count0 = 0 THEN
            nextState <= INIT;
       END IF;
      END IF;
      END IF;
     

      WHEN SECOND =>
        IF count1 = 17 THEN
         reset1 <= '1' ;
         enable1 <= '0';
         nextState <= THIRD;
        ELSE
          IF count1 /= 17 AND x = '0' THEN
          reset0 <= '0' ;
          enable0 <= '1';
         nextState <= FIRST;
        ELSE IF count1 = 0 THEN
         nextSTATE <= curState;
       END IF; 
     END IF; 
    END IF;  
       
       WHEN THIRD =>
        IF x='0' THEN
          reset0 <= '0';
          enable0 <= '1';
          nextState <= FIRST;
      ELSE
          IF x='1' THEN
          nextState <= INIT;
       END IF;
     END IF;
        
      WHEN OTHERS =>
      nextState <= INIT;

    END CASE;
  END PROCESS; -- combi_nextState
  -----------------------------------------------------




  -----------------------------------------------------
  combi_out: PROCESS(curState, x)
  BEGIN
    y <= '0'; -- assign default value
    IF curState = THIRD THEN
      y <= '1';
    END IF;
  END PROCESS; -- combi_output


  -----------------------------------------------------
  seq_state: PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      curState <= INIT;
    ELSIF clk'EVENT AND clk='1' THEN
      curState <= nextState;
    END IF;
  END PROCESS; -- seq
  -----------------------------------------------------



  --counter0 
  ----------------------------------------------------- 
   counter0: process (reset0, enable0, CLK, x, count0, reset)
    BEGIN
      IF reset = '0' THEN
         count0 <= 0;
      ELSE
      IF clk'EVENT AND clk='1' THEN
      IF x = '0' THEN
      IF reset0 = '1' THEN
         count0 <= 0;
      ELSIF reset0 = '0' AND enable0 = '1' THEN
         count0 <= count0 + 1;
        END IF;
       END IF;
      END IF;
     END IF;
    END PROCESS;


   --counter 1
   ------------------------------------------------- 
    counter1: process (reset1, enable1, CLK, x, count1, reset)
     BEGIN
       IF reset = '0' THEN
         count1 <= 0;
       ELSE
       IF clk'EVENT AND clk='1' THEN
       IF x = '1' THEN
       IF reset1 = '1' THEN
         count1 <= 0;
       ELSIF reset1 = '0' AND enable1 = '1' THEN
         count1 <= count1 + 1;
        END IF;
       END IF;
      END IF;
     END IF;
    END PROCESS;

END myArch;
   

 
      
      
