# -*- coding: utf-8 -*-
require 'timeout'

class ExecuteResult
  attr_accessor :out, :err, :status, :status_code
  def initialize(out, err, status_code = -1)
    @status_hash = {0 => "正常終了", 1 => "異常終了", -1 => "タイムアウト"}
    @out = out
    @err = err
    @status_code = status_code
    update_status
  end

  private
  def update_status
    @status = @status_hash[@status_code]
  end
end

class CommandExecutor
  attr_accessor :thread, :result

  def initialize(command, time, file_path, directory_path)
    @pid = nil
    @thread = nil
    @command = command.gsub(/\$file/, file_path).gsub(/\$dir/, directory_path)
    @result = nil
    @time = time
  end

  def execute
    Thread.new{
      out_r, out_w = IO.pipe
      err_r, err_w = IO.pipe
      begin
        timeout(@time){
          @pid = spawn @command, {out: out_w, err: err_w}
          out_w.close
          err_w.close
          @thread = Process.detach(@pid)

          out = out_r.read
          err = err_r.read
          status = @thread.value.exitstatus
          if !err.empty? && status == 0
            puts "waringが起きている可能性があります。\n\n"
            puts err
            puts out
          end
          if status.nil? then
            @result = ExecuteResult.new(out, err, -1)
          else
            @result = ExecuteResult.new(out, err, status)
          end
        }
      rescue Timeout::Error
        puts "タイムアウト"
        force_kill
        @result = ExecuteResult.new('', $!, -1)
      rescue
        puts "異常終了"
        force_kill
        @result = ExecuteResult.new('', $!, 1)
      end
    }
  end

  def force_kill
    Process.kill 'KILL', @pid if @pid != nil && @thread.status
    @thread.kill if !@thread.nil?
  end
end
