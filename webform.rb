# YAML template generator POC
# Rutger Harmers, Intern at HackerOne

require 'sinatra'

# Define the Nuclei YAML templates for different vulnerability categories (just two for now)
xss_template = <<-YAML
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
  else
    return "Invalid selection. Exiting program."
  end

  # Capture the hacker's input for the target and payload variables
  target, payload = capture_input(params[:target], params[:payload])

  # Use the input values to fill in the placeholder variables in the selected template
  template = template.gsub("{{target}}", target)
  template = template.gsub("{{payload}}", payload)

  # Generate the complete Nuclei YAML file
  nuclei_yaml = template

  # Save the Nuclei YAML file to the current directory
  File.write("nuclei_template.yaml", nuclei_yaml)

  # Output the Nuclei YAML file to the terminal
  puts ""
  puts nuclei_yaml    
  puts ""

  # Success page
  send_file 'success.html'
end
  
