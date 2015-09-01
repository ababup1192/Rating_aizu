# -*- coding: utf-8 -*-

class SettingDialog
  def initialize(context)
    @context = context
    @setting = context.setting
    @mailing_path = ""
    @mailing_list_path = ""
    @setting.getparameter(self)
  end
  def view
    window = TkToplevel.new{
      title "設定"
      geometry "600x500"
    }
    TkLabel.new(window, 'text' => "メーリングリスト").pack
    TkButton.new(window, 'text' => "メーリングリスト読込", 'command' => mailing_list).pack
    @mail_file_label = TkLabel.new(window, 'text' => @m_text).pack
    TkLabel.new(window, 'text' => "採点対象ディレクトリ").pack
    TkButton.new(window, 'text' => "採点ディレクトリ読込", 'command' => rating_directory ).pack
    @rating_directory_label = TkLabel.new(window, 'text' => "[#{@r_text}]").pack
    TkLabel.new(window, 'text' => "ファイル拡張子").pack
    @file_extesion = TkEntry.new(window, 'width' => 4).pack
    @file_extesion.value = @f_text
    TkLabel.new(window, 'text' => "区切り文字").pack
    @delimiter = TkEntry.new(window, 'width' => 2).pack
    @delimiter.value = @d_text
    @delimiter.bind('Return', proc{@delimiter_label.text = "s0000000#{@delimiter.value}100"})
    @delimiter_label = TkLabel.new(window, 'text' => "s0000000#{@delimiter.value}100").pack
    TkLabel.new(window, 'text' => 'コンパイルコマンド $file で読込ファイル置換').pack
    @compile_command = TkEntry.new(window).pack
    @compile_command.value = @c_text
    TkLabel.new(window, 'text' => '実行コマンド $dir で実行ディレクトリパス置換').pack
    @exec_command = TkEntry.new(window).pack
    @exec_command.value = @e_text
    TkLabel.new(window, 'text' => '採点ファイル名(採点ディレクトリに保存されます。)').pack
    @result = TkEntry.new(window).pack
    @result.value = @r2_text
    button_frame = TkFrame.new(window).pack
    TkButton.new(button_frame, 'text' => "決定", 'command' =>
      proc{ set_text;@setting.setparameter(self);@context.setting = @setting;@context.rating_setting;window.destroy }).
    pack('padx' => 5,'pady' => 5,'side' => "left")
    TkButton.new(button_frame, 'text' => "キャンセル",'command' => proc{ window.destroy }).
    pack('padx' => 5,'pady' => 5,'side' => "left")
  end
  def mailing_list
    proc{
      path = Tk.getOpenFile
      if !path.empty?
        @mailing_list_path = path
        @mailing_path = File::dirname(path)
        file = path.split("/")[-1]
        @mail_file_label.text =  "[#{file}]"
        @m_text = "[#{file}]"
      end
    }
  end
  def rating_directory
    proc{
      path = Tk.chooseDirectory('initialdir' => @mailing_path)
      if !path.empty?
        @rating_directory_label.text =  "[#{path}]"
        @r_text = path
      end
    }
  end
  def set_text
    @f_text = @file_extesion.value
    @d_text = @delimiter.value
    @c_text = @compile_command.value
    @e_text = @exec_command.value
    @r2_text = @result.value
  end
  attr_accessor :m_text,:mailing_list_path,:mailing_path,:r_text,:f_text,:d_text,:c_text,:e_text,:r2_text
end
