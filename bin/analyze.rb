# analyze.rb

require 'open-uri'
require 'nokogiri'

class Analyzer
    URL = "http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml"
    IGNORE = %w(ALL)

    def initialize()
        xml = self.open_xml
        speeches = self.list_speeches(xml)
        self.puts_speeches(speeches)
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
        if (xml.children.size > 0)
            xml.children.each do |play|
                if (play.children.size > 0 and play.name == "ACT")
                    play.children.each do |act|
                        if (act.children.size > 0 and act.name == "SCENE")
                            act.children.each do |scene|
                                if (scene.children.size > 0 and scene.name == "SPEECH")
                                    current = nil
                                    scene.children.each do |speech|
                                        if (speech.name == "SPEAKER")
                                            current = speech.content
                                            speeches[current] = 1 if (speeches[current] == nil)
                                        end

                                        speeches[current] = speeches[current] + 1 if speech.name == "LINE"
                                    end
                                end
                            end
                        end
                    end
                end
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