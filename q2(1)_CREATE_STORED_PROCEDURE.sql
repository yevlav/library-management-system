--q2--
CREATE OR REPLACE PROCEDURE BORROW_BOOK(i_card_id IN NUMBER, i_book_id IN NUMBER)
IS
	v_is_active NUMBER;
	v_is_available NUMBER;
	
BEGIN
	SELECT COUNT(1) INTO v_is_active FROM Card WHERE Status = 'ACTIVE' AND Card_ID = i_card_id;

	IF v_is_active > 0 THEN
		SELECT COUNT(1) INTO v_is_available FROM Book WHERE Status = 'AVAILABLE' AND Book_ID = i_book_id;

		IF v_is_available > 0 THEN
			INSERT INTO Rental(Card_ID, Book_ID, Rent_Date, Due_Date, Return_Date) VALUES (i_card_id, i_book_id, SYSDATE, SYSDATE + 15, NULL);
			--UPDATE Book SET Status = 'RENTED' WHERE Book_ID = i_book_id;

			DBMS_OUTPUT.PUT_LINE ('The book with ID ' || i_book_id || ' has been borrowed by card ID ' || i_card_id || ' successfully');
		
		ELSE
			DBMS_OUTPUT.PUT_LINE ('The book with ID ' || i_book_id || ' is not available');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE ('The card with ID ' || i_card_id || ' is not active');
	END IF;
	
END BORROW_BOOK;
/