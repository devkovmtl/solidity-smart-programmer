// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
calling parent functions
- direct
- super
    E 
   / \
  F   G
  \  /
   H
 */

contract E {
    event Log(string message);

    function foo() public virtual {
        emit Log("E.foo()");
        E.foo();
    }

    function bar() public virtual {
        emit Log("E.bar()");
        super.bar(); // call all the parents
    }
}
