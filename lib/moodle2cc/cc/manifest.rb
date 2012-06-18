require 'builder'

module Moodle2CC::CC
  class Manifest
    attr_accessor :title, :copyright_and_other_restrictions, :copyright_description,
      :organizations, :resources, :moodle_backup

    def initialize
      @organizations = []
      @resources = []
    end

    def self.from_moodle_backup(moodle_backup)
      manifest = Manifest.new
      manifest.moodle_backup = moodle_backup
      manifest.title = moodle_backup.course.xpath('HEADER/FULLNAME').text
      manifest.copyright_and_other_restrictions = 'yes'
      manifest.copyright_description = 'Private (Copyrighted) - http://en.wikipedia.org/wiki/Copyright'
      manifest.organizations << Organization.from_manifest(manifest)
      manifest
    end

    def write

    end
  end
end
