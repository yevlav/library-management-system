--q4--
CREATE OR REPLACE PROCEDURE RESERVE_BOOK(i_card_id IN NUMBER, i_book_id IN NUMBER)
IS
   v_is_active NUMBER;
   v_is_available NUMBER;
   
BEGIN
	SELECT COUNT(1) INTO v_is_active FROM Card WHERE Status = 'ACTIVE' AND Card_ID = i_card_id;
		
	IF v_is_active > 0 THEN
		SELECT COUNT(1) INTO v_is_available FROM Book WHERE (Status = 'RENTED' OR Status = 'AVAILABLE') AND Book_ID = i_book_id;
						
			IF v_is_available > 0 THEN
				INSERT INTO Reservation(Card_ID, Book_ID, Reservation_Date) VALUES (i_card_id, i_book_id, SYSDATE);
					--UPDATE Book SET Status = 'RESERVED' WHERE Book_ID = i_book_id;
					DBMS_OUTPUT.PUT_LINE ('The book with ID ' || i_book_id || ' has been reserved for the card with ID ' || i_card_id);					
			ELSE
				DBMS_OUTPUT.PUT_LINE ('The book with ID ' || i_book_id || ' is not available to reserve');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE ('The card with ID ' || i_card_id || ' is not active');			
	END IF;
				
END RESERVE_BOOK;
/