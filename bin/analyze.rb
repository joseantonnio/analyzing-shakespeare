# analyze.rb

require 'open-uri'
require 'nokogiri'

class Analyzer
    URL = "http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml"
    IGNORE = %w(ALL)

    def initialize()
        xml = open_xml
        speeches = list_speeches(xml)
        puts_speeches(speeches)
    end

    def open_xml()
        begin
            xml_doc = Nokogiri::XML(URI.open(URL))
        rescue Exception => e
            puts "Error trying to open the file."
        end

        return xml_doc.root
    end

    def list_speeches(xml)
        speeches = {}

        xml.xpath("//SPEECH").each do |scene|
            current = nil
            scene.children.each do |speech|
                if (speech.name == "SPEAKER")
                    current = speech.content
                    speeches[current] = 1 if (speeches[current] == nil)
                end

                speeches[current] = speeches[current] + 1 if speech.name == "LINE"
            end
        end

        return speeches;
    end

    def puts_speeches(speeches)
        speeches.each do |speaker, count|
            puts count.to_s + " " + speaker + "\n"
        end
    end
end

Analyzer.new