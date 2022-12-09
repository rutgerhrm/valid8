# tempgen
Automatically generates pre-defined YAML templates out of user input.  

## YAML Template Generator POC
A simple proof-of-concept Sinatra app to generate Nuclei YAML templates for different vulnerability categories based on user input.

## Requirements
- To run this app, you need to have Sinatra installed. To install Sinatra, run the following command in the terminal:
```gem install sinatra```

## Usage
- Run the code using the command ```ruby webform.rb``` to start the Sinatra server.
- Access the submission form by going to the specified route (in this case, the default route of http://localhost:4567/).
- Select the vulnerability category you want to generate a template for and enter the target and payload values.
- Submit the form to generate the Nuclei YAML template and save it to the current directory.
- The generated template will be output to the terminal and a success page will be displayed in the browser.

## Examples
Here are a few examples of the two different templates that can be generated:

Reflected XSS
```
id: XSS checker

info:
  name: Reflected XSS
  author: Rutger Harmers

requests:
  - method: GET
    path:
      - "{{target}}"

    payloads:
      rce:
        - "{{payload}}"

    checks:
      - type: regex
        target: body
        pattern: "{{payload}}"
```

Open Redirect
```
id: Open redirect checker

info:
  name: Open redirect
  author: Rutger Harmers

requests:
  - method: GET
    path:
      - "{{target}}"

    checks:
      - type: regex
        target: location
        pattern: "{{payload}}"

```

## Contributions
This is a proof-of-concept app and is not intended for production use.

## Credits
Author: Rutger Harmers
