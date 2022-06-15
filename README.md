# ExShop API

This API receives a CNAB file through a HTTP Request to process, parse and store it. The application uses the Flow library to process the transactions in parallel, increasing the performance.

Please check the doc included in this repository for more information on how to use the application.

## Getting Started

### Installing

* Clone the project
* Run `mix deps.get`

### Executing program

* Run `iex -S mix` to execute the program

### Running the unit tests

* Run `mix test`

### Endpoints

* GET - localhost:300/transactions
  - Receives a CNAB file through the query parameters, returns the transactions as JSON.

## Authors

- Rafael Antunes
- dev@rafaelantun.es

## Version History

* 0.1
    * Initial Release
