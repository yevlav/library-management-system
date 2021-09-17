--q6--
CREATE OR REPLACE PROCEDURE LOST_BOOKS(i_card_id IN NUMBER, i_book_id IN NUMBER)
IS
	v_lost_cost NUMBER;
	v_late_fees NUMBER;
BEGIN

	UPDATE Book SET Status = 'LOST' WHERE Book_ID = i_book_id;
	UPDATE Card SET Status = 'INNACTIVE' WHERE Card_ID = i_card_id;
	
	SELECT Lost_Cost INTO v_lost_cost FROM Book WHERE Book_ID = i_book_id;
	SELECT Late_Fees INTO v_late_fees FROM Card WHERE Card_ID = i_card_id;
	
	UPDATE Card SET Late_Fees = v_late_fees + v_lost_cost WHERE Card_ID = i_card_id;
	
	DBMS_OUTPUT.PUT_LINE('Late fees are ' || (v_late_fees + v_lost_cost));

END LOST_BOOKS;
/