import ballerina/io;

LibraryServiceClient endp = check new ("http://localhost:9090");
type BookRecord record {
    string ISBN;
    string title;
    boolean status;
};

public function main() returns error? {
    User[] newUsers = [
        {userId: "1", profile: "User 1"},
        {userId: "2", profile: "User 2"},
        {userId: "3", profile: "User 3"},
        {userId: "4", profile: "User 4"}
    ];

    Create_usersStreamingClient createUsersClient = check  endp->create_users();

    foreach User user in newUsers {
        check createUsersClient->sendUser(user);
        
    }
    
    check createUsersClient->complete();

    string? createUsersResponse = check createUsersClient->receiveString();

    io:println(createUsersResponse);


    AddBookRequest book1 = {
        title: "Grim Reaper Files",
        author_1: "Billy",
        author_2: "Mandy",
        location: "Book-Shelf 1001",
        status: true
    };
    string|error response1 = check endp->add_book(book1);
    io:println("Response: ", response1);

    AddBookRequest book2 = {
        title: "Ben 10 Ultimate Alien",
        author_1: "Benjamin",
        author_2: "Tennisin",
        location: "Book-Shelf 1002",
        status: true
    };
    string|error response2 = check endp->add_book(book2);
    io:println("Response: ", response2);

    AddBookRequest book3 = {
        title: "Demon Slayer",
        author_1: "tanjiro",
        author_2: "Nezuko",
        location: "Book-Shelf 1003",
        status: true
    };
    string|error response3 = check endp->add_book(book3);
    io:println("Response: ", response3);

    io:println("Updating a book...");
    UpdateBookRequest updateBookRequest = {
        ISBN: check response1,
        title: "Tokyo ghoul",
        author_1: "Ken",
        author_2: "Kanaki",
        location: "Book-Shelf 1007",
        status: true
    };
    string|error updateBookResponse = check endp->update_book(updateBookRequest);
    io:println("Update Book Response: ", updateBookResponse);
    
    LocateBookRequest locateBookRequest = {
        ISBN: check response3
    };
    LocateBookResponse|error locateBookResponse = check endp->locate_book(locateBookRequest);
    if (locateBookResponse is LocateBookResponse) {
        io:println("Book Location: ", locateBookResponse.location);
    } else {
        io:println("Failed to locate the book with ISBN: ", locateBookResponse);
    }

    io:println("Borrowing a book...");
    BorrowBookRequest borrowBookRequest = {
        userId: "1",
        ISBN: check response3
    };
    BorrowBookResponse|error borrowBookResponse = check endp->borrow_book(borrowBookRequest);
    if (borrowBookResponse is BorrowBookResponse) {
        io:println("Response: ", borrowBookResponse.message);
    } else {
        io:println("Error: ", borrowBookResponse);
    }

    ListAvailableBooksRequest list_available_booksRequest = {};
    stream<Book, error?> list_available_booksResponse = check endp->list_available_books(list_available_booksRequest);
    check list_available_booksResponse.forEach(function(Book value) {
        io:println(value);
    });
     
    RemoveBookRequest remove_bookRequest = {ISBN: "1435"};
    RemoveBookResponse remove_bookResponse = check endp->remove_book(remove_bookRequest);
    io:println(remove_bookResponse);
    return null;
}
