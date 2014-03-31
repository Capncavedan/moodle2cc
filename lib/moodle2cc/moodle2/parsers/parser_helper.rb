module Moodle2CC::Moodle2::Parsers
  module ParserHelper

    FILES_XML = 'inforef.xml'
    XML_NULL_VALUE = '$@NULL@$'
    MODULE_XML = 'module.xml'

    def activity_directories(work_dir, activity_types)
      File.open(File.join(work_dir, Moodle2CC::Moodle2::Extractor::MOODLE_BACKUP_XML)) do |f|
        moodle_backup_xml = Nokogiri::XML(f)
        activities = moodle_backup_xml./('/moodle_backup/information/contents/activities').xpath("activity[modulename = '#{activity_types}']")
        activities.map { |forum| forum./('directory').text }
      end
    end

    def parse_text(node, xpath, use_xpath=false)
      if v_node = (use_xpath && node.at_xpath(xpath)) || (!use_xpath && node.%(xpath))
        value = v_node.text
        value unless value == XML_NULL_VALUE
      end
    end

    def parse_boolean(node, xpath)
      value = parse_text(node, xpath)
      value && (value == '1' || value.downcase == 'true') ? true : false
    end

    def parse_module(activity_dir, activity)
      File.open(File.join(activity_dir, MODULE_XML)) do |f|
        xml = Nokogiri::XML(f)
        activity.visible = parse_boolean(xml, '/module/visible')
      end
      activity
    end

  end
end
