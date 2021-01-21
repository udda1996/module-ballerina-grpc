// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// This is client implementation for server streaming scenario
import ballerina/io;
import ballerina/test;

@test:Config {enable:true}
function testReceiveStreamingResponseFromReturn() {
    string name = "WSO2";
    // Client endpoint configuration
    HelloWorld25Client helloWorldEp = new("http://localhost:9115");

    var result = helloWorldEp->lotsOfReplies(name);
    if (result is Error) {
        test:assertFail("Error from Connector: " + result.message());
    } else {
        io:println("Connected successfully");
        string[] expectedResults = ["Hi WSO2", "Hey WSO2", "GM WSO2"];
        int count = 0;
        error? e = result.forEach(function(anydata value) {
            if (value != "") {
                test:assertEquals(value, expectedResults[count]);
                count += 1;
            }
        });
        test:assertEquals(count, 3);
    }
}

public client class HelloWorld25Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        Error? result = self.grpcClient.initStub(self, ROOT_DESCRIPTOR_25, getDescriptorMap25());
    }

    isolated remote function lotsOfReplies(string req) returns stream<anydata>|Error {

        var payload = check self.grpcClient->executeServerStreaming("grpcservices.HelloWorld25/lotsOfReplies", req);
        [stream<anydata>, map<string|string[]>][result, _] = payload;

        return result;
    }

}
