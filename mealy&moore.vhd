-- Mealy Machine (mealy.vhd)
-- Asynchronous reset, active low
------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY recog1 IS
PORT(
  x: in STD_ULOGIC;
  clk: in STD_ULOGIC;
  reset: in STD_ULOGIC;
  y: out STD_ULOGIC);
end;

ARCHITECTURE arch_mealy OF recog1 IS
  -- State declaration
  TYPE state_type IS (INIT, FIRST, SECOND, THIRD) ;  -- List your states here 	
  SIGNAL curState, nextState: state_type;
BEGIN
  -----------------------------------------------------

  combi_nextState: PROCESS(curState, x)
  BEGIN
    CASE curState IS
      WHEN INIT =>
        IF x='0' THEN 
          nextState <= curState;
        ELSIF x='1' THEN
            nextState <= FIRST;
        END IF;
     
      WHEN FIRST =>
        IF x='0' THEN
          nextState <= SECOND; 
        ELSIF x='1' THEN
            nextState <= curState;  
        END IF;
       
      WHEN SECOND =>
        IF x='1' THEN
         nextState <= THIRD;
        ELSIF x='0' THEN
         nextState <= INIT;
       END IF;    
       
       WHEN THIRD =>
        IF x='1' THEN
         nextState <= FIRST;
      ELSIF x='0' THEN
          nextState <= INIT;
       END IF;
   
       --This part is for question 15
       --WHEN OTHERS =>
       --   nextState <= INIT;

    END CASE;
  END PROCESS; -- combi_nextState
 ------------------------------------------------------

  -----------------------------------------------------
  combi_out: PROCESS(curState, x)
  BEGIN
    y <= '0'; -- assign default value
    IF curState = THIRD AND x='0' THEN
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
END; -- arch_mealy




-------------------------------------------------------
  --Moore Machine
  ARCHITECTURE arch_moore OF recog1 IS
  -- State declaration
  TYPE state_type IS (INIT, FIRST, SECOND, THIRD, FOURTH);  -- List your states here 	
  SIGNAL curState, nextState: state_type;
BEGIN
   combi_nextState: PROCESS(curState, x)
   BEGIN
     CASE curState IS
    WHEN INIT =>
        IF x='1' THEN
         nextState <= FIRST;
        ELSIF x='0' THEN
         nextState <= curState;
       END IF;   
    
    WHEN FIRST =>
        IF x='1' THEN
         nextState <= curState;
        ELSIF x='0' THEN
         nextState <= SECOND;
       END IF;   
     
    WHEN SECOND =>
        IF x='1' THEN
         nextState <= THIRD;
        ELSIF x='0' THEN
         nextState <= INIT;
       END IF;    
     
     WHEN THIRD =>
        IF x='1' THEN
         nextState <= FIRST;
        ELSIF x='0' THEN
         nextState <= FOURTH;
       END IF;  
     
      WHEN FOURTH =>
        IF x='1' THEN
         nextState <= FIRST;
        ELSIF x='0' THEN
         nextState <= INIT;
       END IF;

      --this part is for question 15
      --WHEN OTHERS =>
      --   nextState <= INIT;
     
       
  END CASE;
  END PROCESS; -- combi_nextState
--------------------------------
combi_out: PROCESS(curState, x)
  BEGIN
    y <= '0'; -- assign default value
    IF curState = FOURTH AND x='0' THEN
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
END; -- arch_moore