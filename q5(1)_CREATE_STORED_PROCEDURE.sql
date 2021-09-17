--q5-- (table Rental)
CREATE OR REPLACE PROCEDURE RETURN_BOOKS(i_card_id IN NUMBER, i_book_id IN NUMBER) 
IS
	v_is_reserved NUMBER;
	v_due_date DATE;
	v_days NUMBER;
	v_late_fees NUMBER;
	
BEGIN
	SELECT COUNT(1) INTO v_is_reserved FROM Book WHERE Status = 'RESERVED' AND Book_ID = i_book_id;
	
		IF v_is_reserved = 0 THEN
			UPDATE Book SET Status = 'AVAILABLE' WHERE Book_ID = i_book_id;
			UPDATE Rental SET Return_Date = SYSDATE WHERE Card_ID = i_card_id AND Book_ID = i_book_id;
	
			SELECT Due_Date INTO v_due_date FROM Rental WHERE Card_ID = i_card_id AND Book_ID = i_book_id;
			SELECT Late_Fees INTO v_late_fees FROM Card WHERE Card_ID = i_card_id;
			
			IF SYSDATE > v_due_date THEN
				v_days := TRUNC(SYSDATE - v_due_date);
				v_late_fees := TRUNC(v_days * 0.25);
				
				UPDATE Card SET Late_Fees = v_late_fees WHERE Card_ID = i_card_id;
				UPDATE Card SET Status = 'INNACTIVE' WHERE Card_ID =  i_card_id;
				
				DBMS_OUTPUT.PUT_LINE ('Your card ' || i_card_id || ' is innactive. You returned the book with ID ' || i_book_id || ' later for ' || v_days || ' days. Your late fees are: ' || v_late_fees || ' $');
			
			ELSE
				DBMS_OUTPUT.PUT_LINE ('The book is not late. You have no late fees');
			END IF;
		ELSE
			DBMS_OUTPUT.PUT_LINE ('The book with ID ' || i_book_id || ' is already reserved by another person');
		END IF;

END RETURN_BOOKS;
/