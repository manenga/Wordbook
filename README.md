# WorkBook: A Transactional Key Value Store

## Purpose
The assignment is to build an interactive interface to a transactional key value store. A user should be able to compile and run this program and get an interactive interface where they can select commands and textfield to enter command value. The user can enter commands to set/get/delete key/value pairs and count values. All values can be treated as strings, no need to differentiate by type. The key/value data only needs to exist in memory for the session, it does not need to be written to disk.

The interface should also allow the user to perform operations in transactions, which allows the user to commit or roll back their changes to the key value store. That includes the ability to nest transactions and roll back and commit within nested transactions.

## Features
```
SET <key> <value> // store the value for key
GET <key>         // return the current value for key
DELETE <key>      // remove the entry for key
COUNT <value>     // return the number of keys that have the given value
BEGIN             // start a new transaction
COMMIT            // complete the current transaction
ROLLBACK          // revert to state prior to BEGIN call
```

## How can I support the developer?
- Star our GitHub repo ⭐
- Create pull requests, submit bugs, suggest new features or documentation updates 🔧
- Follow me on [Twitter](https://twitter.com/mmungandi)
- Follow me on [Instagram](https://instagram.com/mungandi)
- Buy me coffee or [Donate](https://paypal.me/Mungandi)

## More from the developers
- [Rona Mobile App](https://github.com/manenga/Rona/) - Covid19 Global Pandemic Statistics Tracker
- [Luno API Playground](https://github.com/manenga/LunoAPI) - A Swift playground on the Public Luno API.
- [VALR API Playground](https://github.com/manenga/Valr-API) - A Swift playground on the VALR Public API
- [Game of Thrones Character Library](https://github.com/manenga/GameOfThrones) - Mobile App to display content of the API of Fire and Ice.

## License
[Apache](https://github.com/manenga/GameOfThrones/blob/main/LICENSE) license.

## From Developers
Made with ♥ by [Manenga](https://linkedin.com/in/mungandi/). [Support me](https://paypal.me/Mungandi).

## TO-DO's:
- [ ] Demo gif
