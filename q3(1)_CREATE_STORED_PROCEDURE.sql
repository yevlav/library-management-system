--q3--
CREATE OR REPLACE PROCEDURE AUTOMATIC_RENEWAL(i_card_id IN NUMBER, i_book_id IN NUMBER)
IS
	v_is_active NUMBER;
	v_is_reserved NUMBER;
	v_is_available NUMBER;
	v_is_late NUMBER;
	
BEGIN
	SELECT COUNT(1) INTO v_is_active FROM Card WHERE Status = 'ACTIVE' AND Card_ID = i_card_id;
	
	IF v_is_active > 0 THEN
		SELECT COUNT(1) INTO v_is_reserved FROM Reservation WHERE Book_ID = i_book_id;
		
		IF v_is_reserved = 0 THEN
			SELECT COUNT(1) INTO v_is_available FROM Book WHERE Status = 'AVAILABLE' AND Book_ID = i_book_id;
		
			IF v_is_available > 0 THEN
				SELECT COUNT(1) INTO v_is_late FROM Rental WHERE Book_ID = i_book_id AND TO_DATE (TO_CHAR (Due_Date, 'DD-MM-YY')) < TO_DATE (TO_CHAR (SYSDATE, 'DD-MM-YY')) AND Return_Date IS NULL;
				
				IF v_is_late = 0 THEN
					INSERT INTO Rental (Card_ID, Book_ID, Rent_Date, Due_Date, Return_Date) VALUES (i_card_id, i_book_id, SYSDATE, SYSDATE + 15, NULL);
					--UPDATE Book SET Status = 'RENTED' WHERE Book_ID = i_book_id;	
					DBMS_OUTPUT.PUT_LINE ('The automatic renewal for the book with ID ' || i_book_id || ' has been completed succesfully');
					
				ELSE
					DBMS_OUTPUT.PUT_LINE ('The automatic renewal is not allowed if the book is returned after the due date');
				END IF;
				
			ELSE
				DBMS_OUTPUT.PUT_LINE ('The book with ID ' || i_book_id || ' is not available');
			END IF;

		ELSE
			DBMS_OUTPUT.PUT_LINE ('The book with ID ' || i_book_id || ' is already reserved by another person');
		END IF;
		
	ELSE
		DBMS_OUTPUT.PUT_LINE ('The card with ID ' || i_card_id || ' is not active');
	END IF;

END AUTOMATIC_RENEWAL;
/