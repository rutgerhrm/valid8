# Valid8
A simple tool that automates the generation of Nuclei templates based on user-specified parameters. Includes a web-based UI that captures user input.

## Overview
Valid8 is a simple proof-of-concept Sinatra app to generate Nuclei YAML templates for different vulnerability categories based on user input. The project currently supports three vulnerability categories: Reflected XSS, Open Redirect, and PHPinfo() disclosure.


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
git clone https://github.com/rutgerhrm/valid8.git
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
Here are a few examples of the different templates that can be generated:

- Public PHPinfo()
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

![phpinfo.yaml](https://i.imgur.com/oi3gFEH.jpeg "Output php-info.yaml")


- Open Redirect
```yaml
id: valid8-openred

info:
  name: Open Redirect Detection
  author: Rutger Harmers, Princechaddha
  severity: medium

requests:
  - method: GET
    path:
      - "{{target}}"

    payloads:
      redirect:
        - "evil.com"

    fuzzing:
      - part: query
        mode: single
        keys:
          - AuthState
          - URL
          - _url
          - callback
          - checkout
          - checkout_url
          - content
          - continue
          - continueTo
          - counturl
          - data
          - ETC ETC
          
        fuzz:
          - "https://{{redirect}}"

      - part: query
        mode: single
        values:
          - "https?://" 
        fuzz:
          - "https://{{redirect}}"

    stop-at-first-match: true
    matchers-condition: and
    matchers:
      - type: regex
        part: header
        regex:
          - "(?m)^(?:Location\s*?:\s*?)(?:https?:\/\/|\/\/|\/\\\\|\/\\)?(?:[a-zA-Z0-9\-_\.@]*)evil\.com\/?(\/|[^.].*)?$" 

      - type: status
        status:
          - 301
          - 302
          - 307
```
Output:

![openredirect.yaml](https://i.imgur.com/GpILliZ.jpeg "Output openredirect.yaml")

- Reflected XSS
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
Output:

Not yet complete.

---

## About
This is a proof-of-concept app made for an internship project and is not intended for production use.

## Credits
Author: Rutger Harmers
