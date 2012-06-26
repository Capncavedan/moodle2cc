require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCWebLink < MiniTest::Unit::TestCase
  include TestHelper

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 123

    web_link = Moodle2CC::CC::WebLink.new mod
    assert_equal 123, web_link.id
  end

  def test_it_converts_title
    mod = Moodle2CC::Moodle::Mod.new
    mod.name = "About Your Instructor"

    web_link = Moodle2CC::CC::WebLink.new mod
    assert_equal "About Your Instructor", web_link.title
  end

  def test_it_converts_url
    mod = Moodle2CC::Moodle::Mod.new
    mod.reference = "http://en.wikipedia.org/wiki/Einstein"

    web_link = Moodle2CC::CC::WebLink.new mod
    assert_equal "http://en.wikipedia.org/wiki/Einstein", web_link.url
  end

  def test_it_has_an_identifier
    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 123

    web_link = Moodle2CC::CC::WebLink.new mod
    assert_equal 'i802fea43604b8e56736e233ae2ca2ee9', web_link.identifier
  end

  def test_it_creates_xml
    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 123
    mod.name = "About Your Instructor"
    mod.reference = "http://en.wikipedia.org/wiki/Einstein"

    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    web_link = Moodle2CC::CC::WebLink.new mod
    web_link.create_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, "#{web_link.identifier}.xml")))

    assert xml
    assert_equal "http://www.imsglobal.org/xsd/imsccv1p1/imswl_v1p1 http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imswl_v1p1.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://www.imsglobal.org/xsd/imsccv1p1/imswl_v1p1", xml.namespaces['xmlns']
    assert_equal web_link.identifier, xml.xpath('xmlns:webLink').first.attributes['identifier'].value

    assert_equal "About Your Instructor", xml.xpath('xmlns:webLink/xmlns:title').text
    assert xml.xpath('xmlns:webLink/xmlns:url[@href="http://en.wikipedia.org/wiki/Einstein"]').first
  end
end