/*
 * InventoryOps2.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This version of the InventoryOps package contains an extra procedure
 * in the package body.
 */
 
CREATE OR REPLACE PACKAGE InventoryOps AS
  -- Modifies the inventory data for the specified book.
  PROCEDURE UpdateISBN(p_ISBN IN inventory.isbn%TYPE,
                       p_Status IN inventory.status%TYPE,
                       p_StatusDate IN inventory.status_date%TYPE,
                       p_Amount IN inventory.amount%TYPE);

  -- Deletes the inventory data for the specified book.
  PROCEDURE DeleteISBN(p_ISBN IN inventory.isbn%TYPE);
  
  -- Exception raised by UpdateISBN or DeleteISBN when the specified 
  -- ISBN is not in the inventory table.
  e_ISBNNotFound EXCEPTION;
  
  TYPE t_ISBNTable IS TABLE OF inventory.isbn%TYPE
    INDEX BY BINARY_INTEGER;
    
  -- Returns an array containing the books with the specified status.
  PROCEDURE StatusList(p_Status IN inventory.status%TYPE,
                       p_Books OUT t_ISBNTable,
                       p_NumBooks OUT BINARY_INTEGER);
END InventoryOps;
/
show errors

CREATE OR REPLACE PACKAGE BODY InventoryOps AS
  -- Validates the supplied status and raises an error if it is
  -- not IN STOCK, BACKORDERED, or FUTURE.
  PROCEDURE ValidateStatus(p_Status IN inventory.status%TYPE) IS
  BEGIN
    IF p_Status = 'IN STOCK' OR
       p_Status = 'BACKORDERED' OR
       p_Status = 'FUTURE' THEN
       RETURN;  -- No error
    ELSE
      RAISE_APPLICATION_ERROR(20000,
        'Supplied status ' || p_Status || ' is not valid');
    END IF;
  END ValidateStatus;
  
  -- Modifies the inventory data for the specified book.
  PROCEDURE UpdateISBN(p_ISBN IN inventory.isbn%TYPE,
                       p_Status IN inventory.status%TYPE,
                       p_StatusDate IN inventory.status_date%TYPE,
                       p_Amount IN inventory.amount%TYPE) IS
  BEGIN
   ValidateStatus(p_Status);
   UPDATE inventory
      SET status = p_Status, status_date = p_StatusDate, amount = p_Amount
      WHERE isbn = p_ISBN;
      
    -- Check for no books updated, and raise the exception.
    IF SQL%ROWCOUNT = 0 THEN
      RAISE e_ISBNNotFound;
    END IF;
  END UpdateISBN;

  -- Deletes the inventory data for the specified book.
  PROCEDURE DeleteISBN(p_ISBN IN inventory.isbn%TYPE) IS
  BEGIN
    DELETE FROM inventory
      WHERE isbn = p_ISBN;

    -- Check for no books deleted, and raise the exception.
    IF SQL%ROWCOUNT = 0 THEN
      RAISE e_ISBNNotFound;
    END IF;
  END DeleteISBN;

  -- Returns an array containing the books with the specified status.
  PROCEDURE StatusList(p_Status IN inventory.status%TYPE,
                       p_Books OUT t_ISBNTable,
                       p_NumBooks OUT BINARY_INTEGER) IS
    v_ISBN inventory.isbn%TYPE;
    CURSOR c_Books IS
      SELECT isbn
        FROM inventory
        WHERE status = p_Status;
        
  BEGIN
    ValidateStatus(p_Status);

    /* p_NumBooks will be the array index. It will start at
     * 0, and be incremented each time through the fetch loop.
     * At the end of the loop, it will have the number of rows
     * fetched, and therefore the number of rows returned in
     * p_Books. */
     p_NumBooks := 0;
     OPEN c_Books;
     LOOP
       FETCH c_Books INTO v_ISBN;
       EXIT WHEN c_Books%NOTFOUND;

       p_NumBooks := p_NumBooks + 1;       
       p_Books(p_NumBooks) := v_ISBN;
     END LOOP;
     CLOSE c_Books;
   END StatusList;
END InventoryOps;
/
show errors
