// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/grpc;
import ballerina/test;
import ballerina/io;

@test:Config {enable: true}
isolated function testUnarySecuredBlocking() returns grpc:Error? {
    HelloWorld85Client helloWorld9BlockingEp = check new ("https://localhost:9099", {
        secureSocket: {
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            key: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            protocol: {
                name: grpc:TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            }
        }
    });

    string response = check helloWorld9BlockingEp->hello("WSO2");
    test:assertEquals(response, "Hello WSO2");
}

@test:Config {enable: true}
isolated function testUnarySecuredBlockingWithDefaultCerts() returns grpc:Error? {
    HelloWorld85Client helloWorld9BlockingEp = check new ("https://www.google.com");
    io:println("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& Client created &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    string response = check helloWorld9BlockingEp->hello("WSO2");
    io:println("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& Request sent &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    io:println(response);
    test:assertEquals(response, "Hello WSO2");
}
