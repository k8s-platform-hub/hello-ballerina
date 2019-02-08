// Packages contain functions, annotations and connectors.
// This package is referenced by ‘http’ namespace in the code
// body.
import ballerina/http;
import ballerina/io;

// A service is a network-accessible API. This service
// is accessible at '/hello', and bound to a the listener on
// port 9090. `http:Service`is a connector in the `http`
// package.
service hello on new http:Listener(9090) {

  // A resource is an invokable API method.
  // Accessible at '/hello/sayHello’.
  // 'caller' is the client invoking this resource.
  resource function sayHello(http:Caller caller, http:Request request) {

    // Create object to carry data back to caller.
    http:Response response = new;

    // Objects have function calls.
    response.setTextPayload("Hello Ballerina!\n");

    // Send a response back to caller.
    // Errors are ignored with '_'.
    // ‘->’ is a synchronous network-bound call.
    _ = caller -> respond(response);
  }
}

