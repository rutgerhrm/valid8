# YAML template generator POC
# Rutger Harmers

require 'sinatra'

# Define the Nuclei YAML templates for different vulnerability categories (just two for now)
xss_template = <<-YAML
id: valid8-rxss

info:
  name: RXSS Validation
  author: Rutger Harmers
  severity: low

requests:
  - method: GET
    path:
      - '{{target}}'

    matchers-condition: and
    matchers:
      - type: word
        words:
          - '{{payload}}'
        part: body

      - type: word
        words:
          - "text/html"
        part: header

      - type: status
        status:
          - 200
YAML

open_redirect_template = <<-YAML
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
          - "(?m)^(?:Location\s*?:\s*?)(?:https?:\/\/|\/\/|\/\\\\|\/\\)?(?:[a-zA-Z0-9\-_\.@]*)evil\.com\/?(\/|[^.].*)?$" # https://regex101.com/r/ZDYhFh/1

      - type: status
        status:
          - 301
          - 302
          - 307
YAML

phpinfo_template = <<-YAML
id: valid8-phpinfo

info:
  name: PHPinfo Detection
  author: Rutger Harmers
  severity: low

requests:
  - method: GET
    path:
      - "{{target}}"
    matchers:
      - type: word
        words:
          - "PHP Extension"
          - "PHP Version"
        condition: and
YAML

# Create a method to capture user input for the target and payload variables
def capture_input(target, payload)
  return target, payload
end

# Define the Sinatra route to the submission html page
get '/' do
  # Return the HTML page for the submission form
  return File.read("submission.html")
end
  
post '/template' do
  # Use the hacker's choice to select the appropriate template
  if params[:vuln_category] == "1"
    template = xss_template
  elsif params[:vuln_category] == "2"
    template = open_redirect_template
  elsif params[:vuln_category] == "3"
    template = phpinfo_template
  else
    return "Invalid selection. Exiting program."
  end

  # Capture the hacker's input for the target and payload variables
  target, payload = capture_input(params[:target], params[:payload])

  # Get the current time
  start_time = Time.now

  # Use the input values to fill in the placeholder variables in the selected template
  template = template.gsub("{{target}}", target)
  template = template.gsub("{{payload}}", payload)

  # Generate the complete Nuclei YAML file
  nuclei_yaml = template

  # Get the current time
  end_time = Time.now

  # Save the Nuclei YAML file to the current directory
  File.write("nuclei_template.yaml", nuclei_yaml)

  # Output the Nuclei YAML file to the terminal
  puts ""
  puts nuclei_yaml    
  puts ""

  # Calculate the elapsed time
  elapsed_time = (end_time - start_time)
  # Calculate the elapsed time in nanoseconds 
  elapsed_microseconds = elapsed_time.to_f * 1_000_000
  # Output the elapsed time
  puts "Generation time: #{elapsed_microseconds}μs"

  # Success page
  send_file 'success.html'
end
  
