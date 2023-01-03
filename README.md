# Valid8
Automatically generates and executes Nuclei YAML templates out of user-specified target and payload values, all within a user-friendly web interface.

## Overview
Valid8 is a simple proof-of-concept Sinatra app to generate and execute Nuclei YAML templates for different vulnerability categories based on user input, ultimately validating the presence of these vulnerabilities. The project supports three vulnerability categories: Reflected XSS, Open Redirect, and PHPinfo() disclosure.


---

## Requirements
- To run this app, you need to have Sinatra installed. To install Sinatra, run the following command in the terminal:
```bash
$ gem install sinatra
```

## Installation
Download latest release from the [release page](https://github.com/RutgerHrm/valid8/releases/), or try to:

- Clone the repository to your local machine using the following command:
```bash
$ git clone https://github.com/rutgerhrm/valid8.git
```
- Navigate to the root directory of the project:
```bash
$ cd valid8
```
- Install the required gems using the following command:
```bash
$ bundle install
```

---

## Usage
1. Run the programme using the following command:
```bash
ruby tempgen.rb
``` 
2. Access the submission form by navigating to http://localhost:4567/.
3. Select the vulnerability category you want to generate a template for and enter the target and payload values.
4. Click the "Submit report" button to generate the YAML template.
5. The generated template will be output to the terminal and saved to the current directory as ```nuclei_template.yaml```.


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
  author: Rutger Harmers
  severity: medium

requests:
  - method: GET
    path:
      - "http://testphp.vulnweb.com/redir.php?r=https://www.hackerone.com"

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
          - dest
          - dest_url
          - destination
          - dir
          - document
          - domain
          - done
          - download
          - feed
          - file
          - file_name
          - file_url
          - folder
          - folder_url
          - forward
          - from_url
          - go
          - goto
          - host
          - html
          - http
          - https
          - image
          - image_src
          - image_url
          - imageurl
          - img
          - img_url
          - include
          - langTo
          - load_file
          - load_url
          - login_to
          - login_url
          - logout
          - media
          - navigation
          - next
          - next_page
          - open
          - out
          - page
          - page_url
          - pageurl
          - path
          - picture
          - port
          - proxy
          - r
          - r2
          - redir
          - redirect
          - redirectUri
          - redirectUrl
          - redirect_to
          - redirect_uri
          - redirect_url
          - reference
          - referrer
          - req
          - request
          - ret
          - retUrl
          - return
          - returnTo
          - return_path
          - return_to
          - return_url
          - rt
          - rurl
          - show
          - site
          - source
          - src
          - target
          - to
          - u
          - uri
          - url
          - val
          - validate
          - view
          - window
        fuzz:
          - "https://{{redirect}}"

      - part: query
        mode: single
        values:
          - "https?://" # Replace HTTP URLs with alternatives
        fuzz:
          - "https://{{redirect}}"

    stop-at-first-match: true
    matchers-condition: and
    matchers:
      - type: regex
        part: header
        regex:
          - '(?m)^(?:Location\s*?:\s*?)(?:https?:\/\/|\/\/|\/\\\\|\/\\)?(?:[a-zA-Z0-9\-_\.@]*)evil\.com\/?(\/|[^.].*)?$' # https://regex101.com/r/ZDYhFh/1

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
id: valid8-rxss

info:
  name: RXSS Detection
  author: Rutger Harmers
  severity: medium

requests:
  - method: GET
    path:
      - 'http://testphp.vulnweb.com/listproducts.php?cat=><script>alert("XSS")</script>'

    matchers-condition: and
    matchers:
      - type: word
        part: body
        words:
          - '><script>alert("XSS")</script>'
      - type: status
        status:
          - 200
```
Output:

![testxss.yaml](https://i.imgur.com/bmso0on.jpeg "Output testxss.yaml")

---

## About
This is a proof-of-concept app made for an internship project and is not intended for production use.

## Credits
Author: Rutger Harmers
