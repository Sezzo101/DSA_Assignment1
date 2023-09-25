import ballerina/grpc;
import ballerina/random;
import ballerina/log;


listener grpc:Listener ep = new (9090);


type BookRecord record {
    string title;
    string author_1;
    string? author_2;
    string location;
    string ISBN;
    boolean status;
};


@grpc:Descriptor {value: LIBRARY_DESC}
service "LibraryService" on ep {

     remote  function add_book(AddBookRequest value) returns (string|error) {
        string|error uniqueISBN = generateUniqueISBN();
        BookRecord newBook = {
            title: value.title,
            author_1: value.author_1,
            author_2: value.author_2,
            location: value.location,
            ISBN: check uniqueISBN,
            status: value.status
        };
        libraryBooks.push(newBook);
        return uniqueISBN;
    }

    

   remote function update_book(UpdateBookRequest value) returns string|error {
    int bookIndex = findBookIndexByISBN(value.ISBN);
    
    if (bookIndex == -1) {
        return "Book not found";
    } else {
        
        libraryBooks[bookIndex].title = value.title;
        libraryBooks[bookIndex].author_1 = value.author_1;
        libraryBooks[bookIndex].author_2 = value.author_2;
        libraryBooks[bookIndex].location = value.location;
        libraryBooks[bookIndex].status = value.status;
        
        
        return "Book updated successfully";
    }
}
remote function remove_book(RemoveBookRequest value) returns RemoveBookResponse|error {
    
    int bookIndex = findBookIndexByISBN(value.ISBN);

    if (bookIndex == -1) {
        
        return error("Book not found");
    } else {
        
        _ = libraryBooks.remove(bookIndex);

        
        RemoveBookResponse response = {updatedBooks:<Book[]>libraryBooks};

        
        return response;
    }
}






  remote function locate_book(LocateBookRequest value) returns LocateBookResponse|error {
    
    int bookIndex = findBookIndexByISBN(value.ISBN);

    if (bookIndex == -1) {
        
        return error("Book not found");
    } else {
        
        string location = libraryBooks[bookIndex].location;
        LocateBookResponse response = {
            location: location
        };
        return response;
    }
}

remote function borrow_book(BorrowBookRequest value) returns BorrowBookResponse|error {
    string userId = value.userId;
    string ISBN = value.ISBN;
    BorrowBookResponse response = {};

    
    boolean userExists = isUserExists(userId);

    if (!userExists) {
        
        return {message: "User with ID " + userId + " does not exist."};
    }

    
    int bookIndex = findBookIndexByISBN(ISBN);

    if (bookIndex != -1) {
        
        BookRecord book = libraryBooks[bookIndex];

        
        if (book.status) {
            
            
            
            
            response.message = "Book with ISBN " + ISBN + " has been borrowed successfully by User ID " + userId + ".";
            return response;
        } else {
            
            return {message: "Book with ISBN " + ISBN + " is not available for borrowing."};
        }
    } else {
        
        return {message: "Book with ISBN " + ISBN + " not found in the library."};
    }
}


       remote function create_users(stream<User, grpc:Error?> clientStream) returns string|error {
        check clientStream.forEach(function(User user) {
            
            users.push(user);

            
            log:printInfo("Received User: " + user.profile + "\n");
        });

        
        return "Users have been added successfully";
    }
remote function list_available_books(ListAvailableBooksRequest value) returns stream<BookRecord, error?> {
        
        stream<BookRecord, error?> availableBooksStream = new;

        
        foreach BookRecord book in libraryBooks {
            if (book.status) {
                
                
                log:printInfo("Sending available book - ISBN: " + book.ISBN + ", Title: " + book.title);
            }
        }

       
        
        return availableBooksStream;
    }
}







    
  
    
    isolated function generateUniqueISBN() returns string|error {
        
        int min = 1;
        int max = 10000;
        
        int randomNum = check random:createIntInRange(min, max);
        return "ISBN-" + randomNum.toString();
    }




function findBookIndexByISBN(string ISBN) returns int {
    foreach var book in libraryBooks {
        if (book.ISBN == ISBN) {
            return libraryBooks.indexOf(book) ?: 0;
        }
    }
    return -1; 
}


function isUserExists(string userId) returns boolean {
    
    foreach User user in users {
        if (user.userId == userId) {
            return true;
        }
    }
    return false;
}

BookRecord[] libraryBooks = [];
User[] users = [];

