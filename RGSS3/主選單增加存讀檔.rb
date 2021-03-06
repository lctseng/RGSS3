#encoding:utf-8

=begin
*******************************************************************************************

   ＊ 主選單增加存讀檔 ＊

                       for RGSS3

        Ver 1.0.0   2015.08.02

   原作者：魂(Lctseng)，巴哈姆特論壇ID：play123，Github ID：lctseng


   轉載請保留此標籤

   個人小屋連結：http://home.gamer.com.tw/homeindex.php?owner=play123
   RGSS Github：https://github.com/lctseng/RGSS

   主要功能：
                       一、主選單增加讀檔選項

   更新紀錄：
    Ver 1.0.0 ：
    日期：2015.08.02
    摘要：■、最初版本




    撰寫摘要：一、此腳本修改或重新定義以下類別：
                           ■ Scene_Menu
                           ■ Window_MenuCommand



*******************************************************************************************

=end
#*******************************************************************************************
#
#   請勿修改從這裡以下的程式碼，除非你知道你在做什麼！
#   DO NOT MODIFY UNLESS YOU KNOW WHAT TO DO !
#
#*******************************************************************************************

#--------------------------------------------------------------------------
# ★ 紀錄腳本資訊
#--------------------------------------------------------------------------
if !$lctseng_scripts
  $lctseng_scripts = {}
end

_script_sym = :menu_load

$lctseng_scripts[_script_sym] = "1.0.0"

puts "載入腳本：Lctseng - 主選單增加存讀檔，版本：#{$lctseng_scripts[_script_sym]}"


#encoding:utf-8
#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# 　菜單畫面
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # ● 生成指令窗口
  #--------------------------------------------------------------------------
  alias lctseng_menu_load_create_command_window create_command_window unless $@
  def create_command_window(*args,&block)
    lctseng_menu_load_create_command_window(*args,&block)
    @command_window.set_handler(:load,      method(:command_load))
  end
  #--------------------------------------------------------------------------
  # ● 指令“讀檔”
  #--------------------------------------------------------------------------
  def command_load
    SceneManager.call(Scene_Load)
  end
end
#encoding:utf-8
#==============================================================================
# ■ Window_MenuCommand
#------------------------------------------------------------------------------
# 　菜單畫面中顯示指令的窗口
#==============================================================================

class Window_MenuCommand
  #--------------------------------------------------------------------------
  # ● 添加存檔指令 - 重新定義
  #--------------------------------------------------------------------------
  alias lctseng_menu_load_add_save_command add_save_command unless $@
  def add_save_command(*args,&block)
    lctseng_menu_load_add_save_command(*args,&block)
    add_command("讀檔", :load)
  end
end
