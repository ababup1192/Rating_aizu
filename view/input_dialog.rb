# -*- coding: utf-8 -*-

class InputDialog
  def initialize(context)
    @context = context
    @setting = context.setting
  end
  def view
    window = TkToplevel.new{
      title "テストデータ"
      geometry "300x300"
    }
    @test_data = TkText.new(window,'width' => 30,'height' => 15,'borderwidth' => 1,
      'font' => TkFont.new('Inconsolata 12')).pack('pady' => 10)
    @test_data.insert('end',@setting.test_data)
    button_frame = TkFrame.new(window).pack
    TkButton.new(button_frame, 'text' => "決定", 'command' =>
      proc{ @setting.test_data = @test_data.value;@context.setting = @setting;window.destroy }).
    pack('padx' => 5,'pady' => 5,'side' => "left")
    TkButton.new(button_frame, 'text' => "キャンセル",'command' => proc{ window.destroy }).
    pack('padx' => 5,'pady' => 5,'side' => "left")
  end
end
