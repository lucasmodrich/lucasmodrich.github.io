# Converts Wordpress .html to Markdown .md file

# usage: 
# ruby ./wordpress-html-to-md.rb "_posts/post.html"
# ruby ./wordpress-html-to-md.rb "_posts"

# requires: 
# gem install reverse_markdown

require 'fileutils'
require 'reverse_markdown'

# default config
source = "_posts"

if ARGV.length > 0
    source = ARGV[0]
end

# define functions
def open_file_content(file)
    puts "Open '#{file}'"
    fh = open file
    content = fh.read
    fh.close
    return content
end

# usage: `puts convert_html_to_markdown("<b>be bold</b>")`
def convert_html_to_markdown(html, default_frontmatter="")
    # check for Front Matter markdown in HTML
    pattern = /(---.*---)(.*)/m
    htmlcontent = html
    frontmatter = default_frontmatter

    matches = html.match(pattern)
    if matches && matches.length == 3
        puts "Front matter detected..."
        frontmatter = matches[1]
        htmlcontent = matches[2]
        #puts "#{frontmatter}\n#{htmlcontent}"
    end

    puts "Convert HTML to markdown..."
    markdown = ReverseMarkdown.convert(htmlcontent, github_flavored: true)
    puts "Converted HTML to markdown"
    # puts markdown.inspect

    if frontmatter.length > 1
        return "#{frontmatter}\n#{markdown}"
    else
        return markdown
    end
end

def save_file_content(sourceFile, content, ext="md", deleteSourceFile=false)
    destFile = "#{File.dirname(sourceFile)}/#{File.basename(sourceFile,'.*')}.#{ext}"
    puts "Write to file: '#{destFile}'"
    File.write(destFile, content)
    if deleteSourceFile
        FileUtils.remove_file(sourceFile)
    end
end

def convert_html_file_to_md(sourceFile)
  # read file
  content = open_file_content(sourceFile)
  # convert content to markdown
  markdown = convert_html_to_markdown(content, "---\nlayout: post\n---")
  # save file as md. Note: change the deleteSourceFile arg to true to delete the html source file
  save_file_content(sourceFile, markdown, "md", false)
end

# script start
if File.directory?(source)
    sourceFilter = "#{source}**/*.html"
    # process all html files in directory
    i = 0
    Dir.glob(sourceFilter) do |f|
        convert_html_file_to_md(f)
        i += 1
    end
    puts "#{i} html files converted."
elsif File.file?(source)
    convert_html_file_to_md(source)
else
    puts "File not found '#{source}'"
end