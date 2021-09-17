--q1--
SET SERVEROUTPUT ON
SET VERIFY OFF

DECLARE
	PROCEDURE GENERATE_LOGIN_INFO
	IS
	
		CURSOR C_EMPLOYEES
		IS
		SELECT First_Name, Last_Name, Hire_date, Employee_ID FROM Employee FOR UPDATE;

			v_user_emp Employee.Username%TYPE;
			v_pass_emp Employee.Password%TYPE;
				
		CURSOR C_MEMBERS
		IS
		SELECT First_Name, Last_Name, Member_ID, ZIP FROM Member FOR UPDATE;
			   
			v_user_mem Member.Username%TYPE;
			v_pass_mem Member.Password%TYPE;

		BEGIN
		
		FOR v_row IN C_EMPLOYEES
		LOOP
			v_user_emp := LOWER(SUBSTR(v_row.First_Name, 0, 1)) || LOWER(SUBSTR(v_row.Last_Name, 0, 9));
			v_pass_emp := UPPER(SUBSTR(v_row.First_Name, 0, 2)) || TO_CHAR(v_row.Hire_date, 'DD') || UPPER(SUBSTR(v_row.Last_Name, 1, 2)) || TO_CHAR(v_row.Hire_date, 'YYYY');

			--Employee--
			UPDATE Employee SET Username = v_user_emp WHERE Employee_ID = v_row.Employee_ID;
			UPDATE Employee SET Password = v_pass_emp WHERE Employee_ID = v_row.Employee_ID;

			DBMS_OUTPUT.PUT_LINE ('Employee username: ' || v_user_emp);
			DBMS_OUTPUT.PUT_LINE ('Employee password: ' || v_pass_emp);
		END LOOP;

		FOR v_row IN C_MEMBERS
		LOOP
			v_user_mem := UPPER(SUBSTR(v_row.Last_Name, 0, 1)) || LOWER(SUBSTR(v_row.Last_Name, 2, 1)) || v_row.Member_ID;
			v_pass_mem := '00' || UPPER(SUBSTR(v_row.First_Name, 0, 2))|| v_row.ZIP;

			--Member--
			UPDATE Member SET Username = v_user_mem WHERE Member_ID = v_row.Member_ID;
			UPDATE Member SET Password = v_pass_mem WHERE Member_ID = v_row.Member_ID;
	
			DBMS_OUTPUT.PUT_LINE ('Member username: ' || v_user_mem);
			DBMS_OUTPUT.PUT_LINE ('Member password: ' || v_pass_mem);
		END LOOP;
	  
	END GENERATE_LOGIN_INFO;

BEGIN 
	GENERATE_LOGIN_INFO();

EXCEPTION
	WHEN NO_DATA_FOUND THEN 
		DBMS_OUTPUT.PUT_LINE('EXCEPTION: NO DATA FOUND');
END;
/