# YAML template generator POC
# Rutger Harmers, Intern at HackerOne

require 'sinatra'

# Define the Nuclei YAML templates for different vulnerability categories (just two for now)
xss_template = <<-YAML
id: RXSS checker

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
YAML

open_redirect_template = <<-YAML
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
YAML

phpinfo_template = <<-YAML
id: h1check-phpinfo

info:
  name: PHPinfo Disclosure
  author: Rutger Harmers
  severity: low
  description: A “PHPinfo” page was found. The output of the phpinfo() command can reveal detailed PHP environment information.

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
  
