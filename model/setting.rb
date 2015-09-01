# -*- coding: utf-8 -*-

class Setting
  def initialize
    @mailing_list = "[ファイル名]"
    @mailing_list_path = ""
    @mailing_path = ""
    @rating_directory = "ディレクトリ名"
    @file_extension = "c"
    @delimiter = ","
    @compile_command = "gcc $file"
    @exec_command = "./a.out"
    @test_data = ""
    @result = "result"
  end
  def getparameter(context)
    context.m_text = @mailing_list
    context.mailing_list_path = @mailing_list_path
    context.mailing_path = @mailing_path
    context.r_text = @rating_directory
    context.f_text = @file_extension
    context.d_text = @delimiter
    context.c_text = @compile_command
    context.e_text = @exec_command
    context.r2_text = @result
  end
  def setparameter(context)
    @mailing_list = context.m_text
    @mailing_list_path = context.mailing_list_path
    @mailing_path = context.mailing_path
    @rating_directory = context.r_text
    @file_extension = context.f_text
    @delimiter = context.d_text
    @compile_command = context.c_text
    @exec_command = context.e_text
    @result = context.r2_text
  end
  attr_accessor :mailing_list,:mailing_list_path,:mailing_path,:rating_directory,:file_extension,:delimiter,:compile_command,:exec_command,:result,:test_data
end