--q7--
SET SERVEROUTPUT ON
SET VERIFY OFF

DECLARE
	v_book_id NUMBER := &sv_book_id;
	v_status VARCHAR2(20);

BEGIN

DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
DBMS_OUTPUT.PUT_LINE('Add a new book: ');
MANAGE_BOOKS.ADD_BOOK(7777, 'Great Adventures', 'Child', 55);

DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
DBMS_OUTPUT.PUT_LINE('New list of the books: (after adding)');
MANAGE_BOOKS.LIST_ALL_BOOKS('AVAILABLE');

DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
DBMS_OUTPUT.PUT_LINE('Update a book status: ');
MANAGE_BOOKS.UPDATE_BOOK_STATUS(7777, 'LOST');

DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
v_status := MANAGE_BOOKS.GET_BOOK_STATUS(v_book_id);
DBMS_OUTPUT.PUT_LINE('Book ID is: ' || v_book_id || ' and its status is: ' || v_status);

DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
DBMS_OUTPUT.PUT_LINE('Remove a book: ');
MANAGE_BOOKS.REMOVE_BOOK(7777);

DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
DBMS_OUTPUT.PUT_LINE('New list of the books: (after deleting)');
MANAGE_BOOKS.LIST_ALL_BOOKS('AVAILABLE');

EXCEPTION
	WHEN OTHERS THEN
			ROLLBACK;

END;
/