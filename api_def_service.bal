// AUTO-GENERATED FILE.
// This file is auto-generated by the Ballerina OpenAPI tool.

import ballerina/http;
import ballerina/io;


listener http:Listener ep0 = new (9090, config = {host: "localhost"});

Course course1 = {courseName: "Introduction to Computer Science", courseCode: "CS101", nqfLevel: 5};
Course course2 = {courseName: "Data Structures and Algorithms", courseCode: "CS201", nqfLevel: 6};
Course course3 = {courseName: "Database Management", courseCode: "DB101", nqfLevel: 5};
Course course4 = {courseName: "Web Development", courseCode: "WEB101", nqfLevel: 4};
Course course5 = {courseName: "Artificial Intelligence", courseCode: "AI202", nqfLevel: 7};
Course course6 = {courseName: "Machine Learning", courseCode: "ML301", nqfLevel: 7};
Course course7 = {courseName: "Network Security", courseCode: "NET401", nqfLevel: 6};
Course course8 = {courseName: "Software Engineering", courseCode: "SE301", nqfLevel: 6};
Course course9 = {courseName: "Data Science", courseCode: "DS201", nqfLevel: 6};
Course course10 = {courseName: "Human-Computer Interaction", courseCode: "HCI101", nqfLevel: 5};
Course course11 = {courseName: "Distributed Systems", courseCode: "DS401", nqfLevel: 7};
Course course12 = {courseName: "Cloud Computing", courseCode: "CC201", nqfLevel: 6};
Course course13 = {courseName: "Cybersecurity", courseCode: "SEC301", nqfLevel: 6};
Course course14 = {courseName: "Mobile App Development", courseCode: "MOB101", nqfLevel: 5};
Course course15 = {courseName: "Data Warehousing", courseCode: "DW202", nqfLevel: 6};
Course course16 = {courseName: "Computer Graphics", courseCode: "CG101", nqfLevel: 5};
Course course17 = {courseName: "Blockchain Technology", courseCode: "BC401", nqfLevel: 7};
Course course18 = {courseName: "Quantum Computing", courseCode: "QC301", nqfLevel: 8};
Course course19 = {courseName: "Robotics", courseCode: "ROB201", nqfLevel: 7};
Course course20 = {courseName: "Natural Language Processing", courseCode: "NLP301", nqfLevel: 7};

Lecturer lect1 = {staffNumber: "1001", officeNumber: "A1", staffName: "John Doe", title: "Professor",               courses: [course2, course5, course12, course17, course8] };
Lecturer lect2 = {staffNumber: "1002", officeNumber: "A2", staffName: "Jane Smith", title: "Associate Professor",   courses: [course6, course9, course15, course4, course11] };
Lecturer lect3 = {staffNumber: "1003", officeNumber: "A3", staffName: "Bob Johnson", title: "Assistant Professor",  courses: [course10, course3, course14, course19, course7] };
Lecturer lect4 = {staffNumber: "1004", officeNumber: "A4", staffName: "Alice Brown", title: "Lecturer",             courses: [course13, course1, course16, course5, course20] };
Lecturer lect5 = {staffNumber: "1005", officeNumber: "A5", staffName: "Mike Wilson", title: "Professor",            courses: [course18, course2, course7, course10, course12] };
Lecturer lect6 = {staffNumber: "1006", officeNumber: "A6", staffName: "Emily Davis", title: "Associate Professor",  courses: [course4, course11, course3, course8, course19] };
Lecturer lect7 = {staffNumber: "1007", officeNumber: "A7", staffName: "David Lee", title: "Assistant Professor",    courses: [course9, course15, course6, course14, course1] };
Lecturer lect8 = {staffNumber: "1008", officeNumber: "A8", staffName: "Sarah Miller", title: "Lecturer",            courses: [course17, course20, course5, course2, course13] };
Lecturer lect9 = {staffNumber: "1009", officeNumber: "A9", staffName: "Chris Wilson", title: "Professor",           courses: [course3, course18, course11, course7, course4] };
Lecturer lect10 = {staffNumber: "1010", officeNumber: "A1", staffName: "Olivia White", title: "Associate Professor",courses: [course16, course10, course12, course9, course6] };

   Lecturer[] lects = [ lect1,lect2,lect3,lect4,lect5,lect6,lect7,lect8,lect9,lect10];

service / on ep0 {
    # Get a list of all lecturers
    #
    # + return - List of lecturers 
    resource function get lecturers() returns Lecturer[] { return lects; }   
    
    # Add a new lecturer
    #
    # + payload - parameter description 
    # + return - Created 
     resource function post lecturers(@http:Payload Lecturer payload) returns Lecturer {
       io:println("Post Touched !");
       lects.push(payload); 
        return payload;
    }
    # Get details of a specific lecturer by staff number
    #
    # + staffNumber - parameter description 
    # + return - Lecturer details 
    resource function get lecturers / [string staffNumber]() returns Lecturer {
        Lecturer lecturer = {}; 
        // Find the lecturer with the matching staffNumber
        foreach var lect in lects {
            if (lect.staffNumber == staffNumber) {
                lecturer = lect;
                break; // Found the matching lecturer, exit the loop
            }
        } 
        return lecturer;
    }
    # Update an existing lecturer's information
    #
    # + staffNumber - parameter description 
    # + payload - parameter description 
    # + return - Updated 
    resource function put lecturers / [string staffNumber](@http:Payload Lecturer payload) returns Lecturer {
        string requestedStaffNumber = staffNumber;
        int i = 0;
        // Find and update the lecturer with the matching staffNumber
        foreach var lect in lects {
            if (lect.staffNumber == requestedStaffNumber) {
                lects[i] = payload; // Update the lecturer with the new data
                return payload; // Return the updated lecturer
            }
            i = i+1;
        }

        // If no match is found, return an empty Lecturer
        return {};
    }

    # Delete a lecturer's record by staff number
    #
    # + staffNumber - parameter description 
    # + return - No content 
    resource function delete lecturers / [string staffNumber]() returns http:NoContent {
        string requestedStaffNumber = staffNumber;
        int i = 0;

        // Find and remove the lecturer with the matching staffNumber
        int indexToRemove = -1;

        foreach var lect in lects {
            if (lect.staffNumber == requestedStaffNumber) {
                indexToRemove = i;
                break;
            }
            i = i+1;
        }

        if (indexToRemove != -1) {
            _ = lects.remove(indexToRemove); // Remove the lecturer from the array
        }

        // Return a 204 No Content response
    //   return http:NoContent;
        return {};
    }
    # Get all lecturers that teach a certain course
    #
    # + courseCode - parameter description 
    # + return - List of lecturers 
resource function get courses / [string courseCode] / lecturers() returns Lecturer[] {

    Lecturer[] lectsByCourse = [];

    // Find lecturers that teach the specified course
    foreach var lect in lects {
    Course[] courses = <Course[]>lect.courses ;
        foreach var course in courses {
            if(course.courseCode == courseCode){
            lectsByCourse.push(lect); // Add the lecturer to the result array
            }
        }
    }

    return lectsByCourse;
}
  
    # Get all lecturers that sit in the same office
    #
    # + officeNumber - parameter description 
    # + return - List of lecturers 
    resource function get offices / [string officeNumber] / lecturers() returns Lecturer[] {

        Lecturer[] lectsByCourse = [];

        // Find lecturers that sit in the specified office
        foreach var lect in lects {
            if (lect.officeNumber == officeNumber) {
                lectsByCourse.push(lect); // Add the lecturer to the result array
            }
        }
        return lectsByCourse;
    }
}



# Provides a set of configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    ClientHttp1Settings http1Settings?;
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings?;
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache?;
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits?;
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
|};

# Provides settings related to HTTP/1.x protocol.
public type ClientHttp1Settings record {|
    # Specifies whether to reuse a connection for multiple requests
    http:KeepAlive keepAlive = http:KEEPALIVE_AUTO;
    # The chunking behaviour of the request
    http:Chunking chunking = http:CHUNKING_AUTO;
    # Proxy server related options
    ProxyConfig proxy?;
|};

# Proxy server configurations to be used with the HTTP client endpoint.
public type ProxyConfig record {|
    # Host name of the proxy server
    string host = "";
    # Proxy server port
    int port = 0;
    # Proxy server username
    string userName = "";
    # Proxy server password
    @display {label: "", kind: "password"}
    string password = "";
|};

public type LecturerArr Lecturer[];

public type Lecturer record {
    string staffNumber?;
    string officeNumber?;
    string staffName?;
    string title?;
    Course[] courses?;
};

public type Course record {
    string courseName?;
    string courseCode?;
    int nqfLevel?;
};