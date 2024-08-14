# Project XML

This project was created to apply knowledge in ruby ​​on rails.

<table>
  <tr>
    <td>Ruby version</td>
    <td>
      3.0.6
    </td>
  </tr>
  <tr>
    <td>Rails version</td>
    <td>
      6.1.7
    </td>
  </tr>
  <tr>
    <td>Database</td>
    <td>
      PostgreSQL
    </td>
  </tr>
</table>


## Initial settings to run the project

```bash
# install Ruby on Rails dependencies
bundle install

# install Node dependencies
yarn install

# create the development and test databases
rails db:create

# create the tables
rails db:migrate

# run the project
rails s
```

Open the browser at the address `http://localhost:3000`