# -*- coding: utf-8 -*-

require "open3"
require "timeout"
require "thread"

class ExecuteManagement
  def initialize(file_path,directory_path)
    @file_path = file_path
    @directory_path = directory_path
    @compile_result = ""
    @exec_result = ""
  end
  def generate_thread(command,c_flag,input)
    err_flag = false

    command = command.gsub(/\$file/,@file_path)
    command = command.gsub(/\$dir/,@directory_path)
    Thread.new{
      Open3.popen3(command) do |stdin, stdout, stderr|
        if !c_flag
          stdin.write(input)
          stdin.close_write
        end
        stdout.each do |line|
          if c_flag
            @compile_result += line
          else
            @exec_result += line
          end
        end
        stderr.each do |line|
          err_flag = true
          if c_flag
            @compile_result += line
          else
            @exec_result += line
          end
        end
      end
      raise "Error" if err_flag
    }
  end
  def exec_thread(command,c_flag,input)
    thread = generate_thread(command,c_flag,input)
    timeout(0.5){
      loop do
        Thread.pass
        if !thread.alive?
          thread.join
          break
        end
      end
    }
  end
  def exec(context,compile_command,exec_command,input)
    begin
      context.exec_text.clear
      exec_thread(compile_command,true,input)
    rescue Timeout::Error
      context.exec_text.insert('end',"[コンパイル:タイムアウト]\n#{@compile_result}")
    rescue RuntimeError
      context.exec_text.insert('end',"[コンパイル:エラー]\n#{@compile_result}")
    rescue
      context.exec_text.insert('end',"[コンパイル:実行不可能]\n#{@compile_result}")
    else
      context.exec_text.insert('end',"[コンパイル:成功]\n#{@compile_result}")
      exec_next(context,exec_command,input)
    end
  end
  def exec_next(context,exec_command,input)
    begin
      exec_thread(exec_command,false,input)
    rescue Timeout::Error
      context.exec_text.insert('end',"[実行:タイムアウト]\n#{@exec_result}")
    rescue RuntimeError
      context.exec_text.insert('end',"[実行:エラー]\n#{@exec_result}")
    rescue
      context.exec_text.insert('end',"[実行：実行不可能]\n#{@exec_result}")
    else
      context.exec_text.insert('end',"[実行:成功]\n#{@exec_result}")
    end
  end
  attr_accessor :compile_result,:exec_result
end

#em = ExecuteManagement.new("test")
#compile_thread = em.generate_thread("echo aaa","file_management.rb",true)
#exec_thread = em.generate_thread("echo bbb","",false)
#em.exec(compile_thread,exec_thread)
