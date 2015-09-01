require "test/unit"
require "./test_unit_extensions.rb"
require "../file_management.rb"
require "../point_management.rb"

$path = "/Users/watanabemirai/WorkSpace/program/ruby/Rating/data"

class TestInitializeFile < Test::Unit::TestCase
  must "is success? read mail_list" do
    file = FileManagement.new($path,"c",",","result")
    ary_mail_list = file.get_mailing_list("#{$path}/mail_list")
    mail_list = ["s120001", "s120002", "s120003", "s120004"]
    assert_equal mail_list,ary_mail_list
  end
  must "object initialize value equal mailing list" do
    m_file = FileManagement.new($path,"c","\t","result")
    ary_mail_list = m_file.get_mailing_list("#{$path}/mail_list")
    m_point = PointManagement.new(ary_mail_list)
    out_data = {"s120001" => 0,"s120002" => 0,"s120003" => 0,"s120004" => 0}
    #ファイル書き込みテスト
    #m_file.write_result(m_point.point_hash)
    assert_equal out_data,m_point.point_hash
  end
  must "set result equal data" do
   m_file = FileManagement.new($path,"c","\t","result2")
   ary_mail_list = m_file.get_mailing_list("#{$path}/mail_list")
   m_point = PointManagement.new(ary_mail_list)
   m_point.set_point("s120002",5)
   m_point.set_point("s120003",12)
   m_point.set_point("s120004",8)
   out_data = {"s120001" => 0,"s120002" => 5,"s120003" => 12,"s120004" => 8}
   #ファイル書き込みテスト
   #m_file.write_result(m_point.point_hash)
   assert_equal out_data,m_point.point_hash
 end
 must "if output file exists? read file" do
   m_file = FileManagement.new($path,"c","\t","result2")
   ary_mail_list = m_file.get_mailing_list("#{$path}/mail_list")
   m_point = PointManagement.new(ary_mail_list)
   if File.exist?("#{$path}/result2")
      m_point.point_hash = m_file.read_result
    end
    out_data = {"s120001" => 0,"s120002" => 5,"s120003" => 12,"s120004" => 8}
    m_file.delimiter = "\t"
    m_file.write_result(m_point.point_hash)
    assert_equal out_data,m_point.point_hash
  end
end





