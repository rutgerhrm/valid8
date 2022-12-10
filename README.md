# valid8
Automatically generates pre-defined YAML templates out of user input.  

## YAML Template Generator POC
Valid8 is a simple proof-of-concept Sinatra app to generate Nuclei YAML templates for different vulnerability categories based on user input. The project currently supports three vulnerability categories: XSS, open redirect, and PHPinfo disclosure.

## Requirements
- To run this app, you need to have Sinatra installed. To install Sinatra, run the following command in the terminal:
```gem install sinatra```

## Usage
- Run the code using the command ```ruby tempgen.rb``` to start the Sinatra server.
- Access the submission form by going to the specified route (in this case, the default route of http://localhost:4567/).
- Select the vulnerability category you want to generate a template for and enter the target and payload values.
- Click the "Submit report" button to generate the YAML template.
- The generated template will be output to the terminal and saved to the current directory as ```nuclei_template.yaml```.

## Examples
Here are a few examples of two different templates that can be generated:

Public PHPinfo()
```
id: PHPinfo checker

info:
  name: PHPinfo() page
  author: Rutger Harmers

requests:
  - method: GET
    path:
      - "http://testphp.vulnweb.com/secured/phpinfo.php"
    matchers:
      - type: word
        words:
          - "PHP Extension"
          - "PHP Version"
        condition: and
```

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

## About
This is a proof-of-concept app and is not intended for production use.

## Credits
Author: Rutger Harmers - Intern at HackerOne
