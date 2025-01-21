USE library;

# AUTHORS table
CREATE TABLE tbl_book_authors
(	
	book_authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    book_authors_BookID INT NOT NULL,
    book_authors_AuthorName VARCHAR(100) NOT NULL,
    FOREIGN KEY(book_authors_BookID) REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


# BOOKS Table
CREATE TABLE tbl_book
(
	book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    book_Title VARCHAR(255) NOT NULL,
    book_PublisherName VARCHAR(255) NOT NULL,
    FOREIGN KEY(book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


# PUBLISHER Table
CREATE TABLE tbl_publisher
(
	publisher_PublisherName VARCHAR(100) PRIMARY KEY,
    publisher_PublisherAddress VARCHAR(255) NOT NULL,
    publisher_PublisherPhone VARCHAR(20)
);


# Book Copies Table
CREATE TABLE tbl_book_copies
(	
    book_copies_BookID INT NOT NULL,
    book_copies_BranchID INT NOT NULL,
    book_copies_No_Of_Copies INT NOT NULL,
    book_copies_CopiesID INT AUTO_INCREMENT PRIMARY KEY,
    FOREIGN KEY(book_copies_BookID) REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


# Library Branch Table
CREATE TABLE tbl_library_branch
(
	library_branch_BranchID INT AUTO_INCREMENT PRIMARY KEY,
    library_branch_BranchName VARCHAR(200) NOT NULL,
    library_branch_BranchAddress VARCHAR(225) NOT NULL
);


# Book Loans Table
CREATE TABLE tbl_book_loans
(
	book_loans_BookID INT NOT NULL,
    book_loans_BranchID INT NOT NULL,
    book_loans_CardNo INT NOT NULL,
	book_loans_DateOut Date,
    book_loans_DueDate Date,
	book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY,
    FOREIGN KEY(book_loans_BookID) REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


# Borrower Table
CREATE TABLE tbl_borrower
(
	borrower_CardNo INT AUTO_INCREMENT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(100) NOT NULL,
    borrower_BorrowerAddress VARCHAR(225) NOT NULL,
    borrower_BorrowerPhone VARCHAR(20) NOT NULL
);


SELECT * FROM tbl_book;
SELECT * FROM TBL_BOOK_AUTHORS;
SELECT * FROM tbl_book_copies;
SELECT * FROM tbl_book_loans;
SELECT * FROM tbl_borrower;
SELECT * FROM tbl_library_branch;
SELECT * FROM tbl_publisher;


-- Task Questions 

# 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"? 

SELECT book_copies_No_Of_Copies AS count_of_copies
FROM tbl_book_copies copies
JOIN tbl_book books
	ON copies.book_copies_BookID = books.book_BookID
JOIN tbl_library_branch library
	ON copies.book_copies_BranchID = library.library_branch_BranchID
WHERE books.book_Title = "The Lost Tribe" AND 
	  library.library_branch_BranchName = "Sharpstown";
      
      
# 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch? 
      
SELECT book_copies_No_Of_Copies AS count_of_copies,
	   library.library_branch_BranchName AS Branch
FROM tbl_book_copies copies
JOIN tbl_book books
	ON copies.book_copies_BookID = books.book_BookID
JOIN tbl_library_branch library
	ON copies.book_copies_BranchID = library.library_branch_BranchID
WHERE books.book_Title = "The Lost Tribe";


# 3. Retrieve the names of all borrowers who do not have any books checked out.

SELECT borrower_CardNo AS Card_No,
	   borrower_BorrowerName AS Name
FROM tbl_borrower B
LEFT JOIN tbl_book_loans L
	ON B.borrower_CardNo = L.book_loans_CardNo
WHERE L.book_loans_CardNo IS NULL;

/*
4. For each book that is loaned out from the "Sharpstown" branch and whose 
DueDate is 2/3/18, retrieve the book title, the borrower's name, and the 
borrower's address.  
*/
SELECT B.book_Title AS Book_Title,
	   BR.borrower_BorrowerName AS Borrower_Name,
       BR.borrower_BorrowerAddress AS Borrower_Address
FROM tbl_book_loans BL
INNER JOIN tbl_book B
	ON BL.book_loans_BookID = B.book_BookID
INNER JOIN tbl_borrower BR
	ON BL.book_loans_CardNo = BR.borrower_CardNo
INNER JOIN tbl_library_branch LB
	ON BL.book_loans_BranchID = LB.library_branch_BranchID
WHERE 
	LB.library_branch_BranchName = "Sharpstown" AND 
    BL.book_loans_DueDate = "2018-02-03";
	   

# 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch. 

SELECT library_branch_BranchName AS Branch_Name,
	   COUNT(book_loans_BookID) AS Total_Books_Out
FROM tbl_library_branch LB
LEFT JOIN tbl_book_loans BL 
	ON LB.library_branch_BranchID = BL.book_loans_BranchID
GROUP BY LB.library_branch_BranchName;


# 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out. 

SELECT BR.borrower_BorrowerName AS Borrower_Name,
	   BR.borrower_BorrowerAddress AS Borrower_Address,
       COUNT(BL.book_loans_BookID) AS No_Of_Books_Checked_Out
FROM tbl_borrower BR
JOIN tbl_book_loans BL
	ON BR.borrower_CardNo = BL.book_loans_CardNo
GROUP BY 
	BR.borrower_CardNo,
    BR.borrower_BorrowerName,
    BR.borrower_BorrowerAddress
HAVING 
	COUNT(BL.book_loans_BookID) > 5;
    

# 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central". 

SELECT B.book_Title AS Book_Title,
	   BC.book_copies_No_Of_Copies AS Copies_Count
FROM tbl_book_authors BA
INNER JOIN tbl_book B
	ON BA.book_authors_BookID = B.book_BookID
INNER JOIN tbl_book_copies BC
	ON B.book_BookID = BC.book_copies_BookID
INNER JOIN tbl_library_branch LB
	ON BC.book_copies_BranchID = LB.library_branch_BranchID
WHERE 
	BA.book_authors_AuthorName = "Stephen King" AND
    LB.library_branch_BranchName = "Central";






