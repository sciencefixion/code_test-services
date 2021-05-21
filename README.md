# QA API Code Test

It is time to run some tests against OMDb API - The Open Movie Database!

## Setup

#### Usage Requirements

  Sign up for the API key required to run these tests via the link below.

  [OMDb API](http://www.omdbapi.com/apikey.aspx)

#### Configuration

  Run the following commands.

1. ```
   $ git clone git@github.com:sciencefixion/code_test-services.git
   ```

2. ```
   $ cd Code\ Test\ -\ Services/
   ```

3. ```
   $ bundle install
   ```

4. ```
   $ touch .env
   ```

5. Add API key to .env file in the root directory in the following format:
  ```ruby
  export OMDB_KEY=YOUR_API_KEY
  ```

6. Run the test suite from the root directory with this command:

  ```
  $ ruby ./suite/api_test.rb
  ```

## Completed Tasks:

  1. Successfully made api requests to OMDb API from within tests in api_test.rb.

  2. Added an assertion to test_no_api_key to ensure the response at runtime matches what is currently displayed with the api key missing.

  3. Extended api_test.rb by creating a test that performs a search on 'thomas'.

  - Verified all titles are a relevant match.
  - Verified keys include Title, Year, imdbID, Type, and Poster for all records in the response.
  - Verified values are all of the correct object class.
  - Verified year matches correct format.


  4. Added a test that uses the i parameter to verify each title on page one is accessible via imdbID.

  5. Added a test that verifies none of the poster links on page one are broken.

  6. Added a test that verifies there are no duplicate records across the first five pages.

  7. Added a test that verifies something you are curious about with regard to movies or data in the database.
