# Valid8
Automatically generates pre-defined YAML templates out of user input.  

## Overview
Valid8 is a simple proof-of-concept Sinatra app to generate Nuclei YAML templates for different vulnerability categories based on user input. The project currently supports three vulnerability categories: XSS, Open Redirect, and PHPinfo() disclosure.

---

## Requirements
- To run this app, you need to have Sinatra installed. To install Sinatra, run the following command in the terminal:
```bash
gem install sinatra
```

## Installation
Download latest release from the [release page](https://github.com/RutgerHrm/valid8/releases/), or try to:

- Clone the repository to your local machine using the following command:
```bash
git clone https://github.com/RutgerHrm/valid8.git
```
- Navigate to the root directory of the project:
```bash
cd valid8
```
- Install the required gems using the following command:
```bash
bundle install
```

---

## Usage
- Run the programme using the following command:
```bash
ruby tempgen.rb
``` 
- Access the submission form by navigating to http://localhost:4567/.
- Select the vulnerability category you want to generate a template for and enter the target and payload values.
- Click the "Submit report" button to generate the YAML template.
- The generated template will be output to the terminal and saved to the current directory as ```nuclei_template.yaml```.


## Examples
Here are a few examples of two different templates that can be generated:

Public PHPinfo()
```yaml
id: valid8-phpinfo

info:
  name: PHPinfo Disclosure
  author: Rutger Harmers
  severity: low

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
Output: 
![alt text](https://i.imgur.com/ENCSQe7.jpeg "php-info.yaml output")


Reflected XSS
```yaml
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

---

## About
This is a proof-of-concept app made for an internship project and is not intended for production use.

## Credits
Author: Rutger Harmers
