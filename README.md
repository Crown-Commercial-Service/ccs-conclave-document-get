# CCS CONCLAVE DOCUMENT GET SERVICE
This is the GET service which is part of the Conclave Document Upload Services

## Nomenclature

- **Client**: used for basic token authentication. For each application that can post to this service, a Client object needs to be created
- **Document**: used to store the state of the file and to retrieve the file once threat scanning succeeds

## Technical documentation

This is a Ruby on Rails application that takes a document_id and retrieves the Document and the attached document_file. It's only presented as an internal API and doesn't face public users.

### Setup instructions
#### For OSX/macOS version 10.9 or higher

##### 1. Install command line tools on terminal

`xcode-select --install`

##### 2. Install Hombrew

`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

##### 2. Install rbenv

`brew update`
`brew install rbenv`
`echo 'eval "$(rbenv init -)"' >> ~/.bash_profile`
`source ~/.bash_profile`

##### 3. Build ruby 2.7.2 with rbenv

`rbenv install 2.7.2`
`rbenv global 2.7.2`

##### 4. Install rails 6.0.3
`gem install rails -v 6.0.3`

#### 5. Download and install Postgresql 10
Go to https://www.postgresql.org/ and download the installer

#### 7. Create and migrate the database
`rake db:create && rake db:migrate`

### Running the application

From your console run the rails server:
`rails s`

You can now use the service by sending a GET request to: `localhost:3000/document/:id`

### Running the test suite

To run the specs, from your console do:
`rspec spec`
