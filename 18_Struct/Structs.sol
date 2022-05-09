// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Struct {
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;
    mapping(address => Car[]) public carsByOwner;

    // 3 ways to initialize a struct
    function examples() external {
        // 1. direct initialization
        Car memory toyota = Car("Toyota", 1980, msg.sender);

        Car memory lambo = Car({
            model: "Lamborghini", year:1999, owner: msg.sender});

        Car memory tesla; // default value of type
        tesla.model = "Tesla";
        tesla.year = 2018;
        tesla.owner = msg.sender;

        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);

        cars.push(Car("Ferrari", 2018, msg.sender));

        // load the car memory we dont change anything
        // memory means wil load into memory once function 
        // finish executing the modification will be lost
        Car memory _car = cars[3];
        _car.model;

        // if we want to change model, car etc... we will need to remove memory
        // we want to update the car
        Car storage _car1 = cars[1];
        _car1.year = 2020;
        delete _car.owner;

        delete cars[2]; // reset to default value 

    }
}