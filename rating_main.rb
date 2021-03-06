# -*- coding: utf-8 -*-

require "tk"
# require_relative './model/execute_management.rb'
require_relative './model/io.rb'
require_relative './model/file_management.rb'
require_relative './model/point_management.rb'
require_relative './model/setting.rb'
require_relative './view/setting_dialog'
require_relative './view/input_dialog'

class MainWindow
  def initialize
    @setting = Setting.new
    @mailing_list = []
    @file = nil
    view
  end
  def view
    root = TkRoot.new{
      title "採点ツール"
      geometry "1000x630"
    }

    file_menu = TkMenu.new(root)
    file_menu.add('command',
      'label'     => "採点開始",
      'command'   => proc{SettingDialog.new(self).view},
      'underline' => 0)
    file_menu.add('command',
      'label'     => "終了",
      'command'   => proc{root.destroy},
      'underline' => 0)
    menu_bar = TkMenu.new
    menu_bar.add('cascade','menu'  => file_menu,'label' => "File")
    root.menu(menu_bar)

    # Short cut list
    shortcut_frame = TkFrame.new(root).pack
    TkLabel.new(shortcut_frame, 'text' => "F1:").pack('padx' => 10, 'pady' => 10,'side' => 'left')
    @shortcut_1 = TkEntry.new(shortcut_frame, 'width' => 4).pack('padx' => 10, 'pady' => 10,'side' => 'left')
    TkLabel.new(shortcut_frame, 'text' => "F2:").pack('padx' => 10, 'pady' => 10,'side' => 'left')
    @shortcut_2 = TkEntry.new(shortcut_frame, 'width' => 4).pack('padx' => 10, 'pady' => 10,'side' => 'left')
    TkLabel.new(shortcut_frame, 'text' => "F3:").pack('padx' => 10, 'pady' => 10,'side' => 'left')
    @shortcut_3 = TkEntry.new(shortcut_frame, 'width' => 4).pack('padx' => 10, 'pady' => 10,'side' => 'left')

    button_frame = TkFrame.new(root).pack
    TkButton.new(button_frame, 'text' => "保存",'command' =>
     proc{ @file.write_result(@mailing_list) if !@file.nil? }).pack('padx' => 10, 'pady' => 10,'side' => 'left')
    TkButton.new(button_frame, 'text' => "設定",'command' => proc{ SettingDialog.new(self).view }).
    pack('padx' => 10 ,'pady' => 10,'side' => 'left')
    TkButton.new(button_frame, 'text' => "テストデータ",'command' =>
     proc{ InputDialog.new(self).view }).pack('padx' => 10, 'pady' => 10,'side' => 'left')
    TkButton.new(button_frame, 'text' => "終了",'command' => proc{ root.destroy }).
    pack('padx' => 10, 'pady' => 10,'side' => 'left')
    label_frame = TkFrame.new(root).pack('fill' => 'x', 'pady' => 10)
    TkLabel.new(label_frame, 'text' => "学籍番号/成績").pack('side' => 'left', 'padx' => 100)
    TkLabel.new(label_frame, 'text' => "実行結果").pack('side' => 'left', 'padx' => 100)
    TkLabel.new(label_frame, 'text' => "ソースコード").pack('side' => 'left', 'padx' => 160)
    list_frame = TkFrame.new(root).pack('fill' => 'x' , 'padx' => 40)
    @list = TkListbox.new(list_frame,'width' => 20, 'height' => 20).pack('side' => 'left')
    TkScrollbar.new(list_frame)
    @exec_text = TkText.new(list_frame,'width' => 35,'height' => 22,'borderwidth' => 1,
      'font' => TkFont.new('Inconsolata 12')).pack('side' => "left",  'padx'=> "50")
    @source_text = TkText.new(list_frame,'width' => 35,'height' => 22,'borderwidth' => 1,
      'font' => TkFont.new('Inconsolata 12')).pack('side' => "left",  'padx' => "30")
    @list.bind('ButtonRelease-1', proc{list_click})
    @list.bind('KeyRelease',proc{list_click})
    @list.bind('Return', proc{@score.focus})

    rating_frame = TkFrame.new(root).pack('fill' => 'x', 'padx' => 20)
    @score_label = TkLabel.new(rating_frame, 'text' => "[学籍番号]").pack('side' => "left" ,'padx' => 10,'pady' => 20)
    @score = TkEntry.new(rating_frame,'width' => 3,'state' => "disabled").pack('side' => "left",'padx' => 10,'pady' => 20)
    @score.bind('Return',proc{
      begin
        @mailing_list = @point.set_point(@score_label.text,@score.value)
        list_insert
        @list.selection_set(@list_index)
        @list.focus
        @list.activate(@list_index)
      rescue
      end
    })

    # list shotcut key
    @shortcut_flag = false
    @list.bind('Key', proc{|e|
       case e.keycode
       when 67, 8058628
         @shortcut_flag = true
         @score.value = @shortcut_1.value
       when 68, 7927557
         @shortcut_flag = true
         @score.value = @shortcut_2.value
       when 69, 6551302
         @shortcut_flag = true
         @score.value = @shortcut_3.value
       end
   })

    Tk.mainloop
  end
  def list_insert
    @list.clear
    @mailing_list.each do |key,value|
      @list.insert 'end',"#{key} => #{value}"
    end
  end
  def list_click
    if @list.size != 0
      @list_index = @list.curselection
      list_value = @list.get(@list.curselection)
      key = list_value.split(" => ")[0]
      source_file = "#{@file.rating_dir}/#{key}.#{@file.file_extension}"
      open_source(source_file)
      exec_source(source_file,"#{@file.rating_dir}/")
      @score_label.text = list_value.split(" => ")[0]
      if @shortcut_flag then
        @shortcut_flag = false
        @score.focus
        # @list.activate(@list_index)
      else
        @score.value = list_value.split(" => ")[1]
      end
    end
  end
  def open_source(file_path)
    @source_text.clear
    begin
      timeout(0.5){
        File::open(file_path) {|f|
          f.each {|line| @source_text.insert('end',line)}
        }
      }
    rescue Timeout::Error
      @source_text.insert('end',"ファイルサイズが大きすぎるため開くことが出来ません。")
    rescue
      @source_text.insert('end',"#{file_path}は、存在しません。")
    end
  end
  def exec_source(file_path,directory_path)
    @em = nil if !@em.nil?
    Thread.new{
      comp_executor = CommandExecutor.new(@setting.compile_command, 3, file_path, directory_path)
      run_executor = CommandExecutor.new(@setting.exec_command, 3, file_path, directory_path)
      comp_executor.execute()
      run_executor.execute()
      loop{
        if !comp_executor.result.nil? && !run_executor.nil? then
          p comp_executor.result
          p run_executor.result
          break
        end
        sleep 0.2
      }
    }
      # @em = ExecuteManagement.new(file_path,directory_path)
    # @em.exec(self,@setting.compile_command,@setting.exec_command,@setting.test_data)
  end
  def rating_setting
    @file = FileManagement.new(@setting.rating_directory,@setting.file_extension,@setting.delimiter,@setting.result)
    arr = @file.get_mailing_list(@setting.mailing_list_path)
    @score.state = "normal" if !arr.empty?
    @point = PointManagement.new(arr)
    hash = @file.read_result
    if !hash.empty?
      @mailing_list = hash
      @point.point_hash = hash
      @setting.delimiter = @file.delimiter
      list_insert
    else
      @mailing_list = @point.reset_points
      list_insert
    end
  end
  attr_accessor :setting,:mailing_list,:exec_text
end

MainWindow.new
