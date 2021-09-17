--q7--
CREATE OR REPLACE PACKAGE BODY MANAGE_BOOKS
AS
--------------------------------------------
	PROCEDURE ADD_BOOK (i_book_id IN NUMBER, i_title IN VARCHAR2, i_category IN VARCHAR2, i_cost IN NUMBER)
	IS
	BEGIN
		INSERT INTO Book (Book_ID, Title, Category, Status, Lost_Cost) VALUES (i_book_id, i_title, i_category, 'AVAILABLE', i_cost);

		DBMS_OUTPUT.PUT_LINE ('The book with ID ' || i_book_id || ' has been added');

		EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			DBMS_OUTPUT.PUT_LINE('ERROR: duplicated ID: Book already exists');
	END ADD_BOOK;
--------------------------------------------
	PROCEDURE REMOVE_BOOK (i_book_id IN NUMBER)
	IS
	BEGIN
		DELETE FROM Book WHERE Book_ID = i_book_id;

		DBMS_OUTPUT.PUT_LINE ('The book with ID ' || i_book_id || ' has been deleted');

		IF SQL%ROWCOUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('The book with ID ' || i_book_id || ' is not found');	
		END IF;
	END REMOVE_BOOK;
--------------------------------------------
	PROCEDURE LIST_ALL_BOOKS (i_status IN VARCHAR2)
	IS
		CURSOR C
		IS
			SELECT * FROM Book WHERE Status = i_status;
	BEGIN
		FOR row_book IN C
		LOOP
			DBMS_OUTPUT.PUT_LINE ('Book ID: ' || row_book.Book_ID);
			DBMS_OUTPUT.PUT_LINE ('Title: ' || row_book.Title);
			DBMS_OUTPUT.PUT_LINE ('Category: ' || row_book.Category);
			DBMS_OUTPUT.PUT_LINE ('Status: ' || row_book.Status);
			DBMS_OUTPUT.PUT_LINE ('Lost cost: ' || row_book.Lost_Cost);
			DBMS_OUTPUT.PUT_LINE (CHR (10));
		END LOOP;
	END LIST_ALL_BOOKS;
--------------------------------------------
	PROCEDURE UPDATE_BOOK_STATUS (i_book_id IN NUMBER, i_status IN VARCHAR2)
	IS
	BEGIN
		UPDATE Book SET Status = i_status WHERE Book_ID = i_book_id;

		DBMS_OUTPUT.PUT_LINE ('The status of the book with ID ' || i_book_id || ' has been updated');

		IF SQL%ROWCOUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('ERROR: Nothing was updated');	
		END IF;
	END UPDATE_BOOK_STATUS;
--------------------------------------------
	FUNCTION GET_BOOK_STATUS (i_book_id IN NUMBER) RETURN VARCHAR2
	IS
      v_status VARCHAR2 (20);
	BEGIN
		SELECT Status INTO v_status FROM Book WHERE Book_ID = i_book_id;

		RETURN v_status;
		
		EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('ERROR: The Book with status ' || v_status || ' is not found');
				RETURN v_status;
	END GET_BOOK_STATUS;
	
END MANAGE_BOOKS;
/