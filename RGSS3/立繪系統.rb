#encoding:utf-8

=begin
*******************************************************************************************

   ＊ 立繪系統 ＊

                       for RGSS3

        Ver 1.11   2014.11.05

   原作者：魂(Lctseng)，巴哈姆特論壇ID：play123
   

   轉載請保留此標籤

   個人小屋連結：http://home.gamer.com.tw/homeindex.php?owner=play123

   需求前置腳本：Lctseng - 圖像精靈強化
   請將此腳本至於該腳本底下
   
   主要功能：
                       一、顯示左右邊的立繪，與對話框分開(即沒有關聯)
                       

   更新紀錄：
    Ver 1.00 ：
    日期：2014.09.24
    摘要：■、最初版本
    
    
    Ver 1.10 ：
    日期：2014.10.30
    摘要：■、加入調整透明度的功能
    
    
    Ver 1.11 ：
    日期：2014.11.05
    摘要：■、修正立即出現沒有調整透明度的錯誤
    
    撰寫摘要：一、此腳本修改或重新定義以下類別：
                           ■ Game_Interpreter
                           ■ Game_System
                           ■ Window_Message
                           ■ Scene_Base
                           ■ Scene_Map
                          
                        二、此腳本新定義以下類別和模組：
                           ■ Lctseng::Game_StandController
                           ■ Lctseng::Game_Stand
                           ■ Lctseng::Game_LeftStand
                           ■ Lctseng::Game_RightStand
                           ■ Lctseng::Spriteset_Stand
                           ■ Lctseng::Sprite_Stand
                           ■ Lctseng::Sprite_LeftStand
                           ■ Lctseng::Sprite_RightStand
                          

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

## 檢查前置腳本
if !$lctseng_scripts[:sprite_ex]
  msgbox("沒有發現前置腳本：Lctseng - 圖像精靈強化\n或者是腳本位置錯誤！\n程式即將關閉")
  exit
end


$lctseng_scripts[:stand_picture] = "1.11"

puts "載入腳本：Lctseng - 立繪系統，版本：#{$lctseng_scripts[:stand_picture]}"



#encoding:utf-8
#==============================================================================
# ■ Game_Interpreter
#------------------------------------------------------------------------------
# 　事件指令的解釋器。
#   本類在 Game_Map、Game_Troop、Game_Event 類的內部使用。
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 左圖片飛入
  #--------------------------------------------------------------------------
  def left_slide_in(*args)
    $game_system.stand.left_slide_in(*args)
  end
  #--------------------------------------------------------------------------
  # ● 左圖片飛出
  #--------------------------------------------------------------------------
  def left_slide_out(*args)
    $game_system.stand.left_slide_out(*args)
  end
  #--------------------------------------------------------------------------
  # ● 左圖片更換
  #--------------------------------------------------------------------------
  def left_change(*args)
    $game_system.stand.left_change(*args)
  end
  
  #--------------------------------------------------------------------------
  # ● 右圖片飛入
  #--------------------------------------------------------------------------
  def right_slide_in(*args)
    $game_system.stand.right_slide_in(*args)
  end
  #--------------------------------------------------------------------------
  # ● 右圖片飛出
  #--------------------------------------------------------------------------
  def right_slide_out(*args)
    $game_system.stand.right_slide_out(*args)
  end
  #--------------------------------------------------------------------------
  # ● 右圖片更換
  #--------------------------------------------------------------------------
  def right_change(*args)
    $game_system.stand.right_change(*args)
  end
  #--------------------------------------------------------------------------
  # ● 左圖片Z座標更換
  #--------------------------------------------------------------------------
  def left_z(val)
    $game_system.stand.left.z = val
  end
  #--------------------------------------------------------------------------
  # ● 右圖片Z座標更換
  #--------------------------------------------------------------------------
  def right_z(val)
    $game_system.stand.right.z = val
  end
  #--------------------------------------------------------------------------
  # ● 左圖片在對話框前
  #--------------------------------------------------------------------------
  def left_front
    left_z(500)
  end
  #--------------------------------------------------------------------------
  # ● 左圖片在對話框後
  #--------------------------------------------------------------------------
  def left_behind
    left_z(50)
  end
  #--------------------------------------------------------------------------
  # ● 右圖片在對話框前
  #-------------------------------------------------------------------------
  def right_front
    right_z(500)
  end
  #--------------------------------------------------------------------------
  # ● 右圖片在對話框後
  #--------------------------------------------------------------------------
  def right_behind
    right_z(50)
  end
  #--------------------------------------------------------------------------
  # ● 左圖片最大透明限制
  #--------------------------------------------------------------------------
  def left_limit_opacity(*args)
    $game_system.stand.left_limit_opacity(*args)
  end
  #--------------------------------------------------------------------------
  # ● 右圖片最大透明限制
  #--------------------------------------------------------------------------
  def right_limit_opacity(*args)
    $game_system.stand.right_limit_opacity(*args)
  end

end
  

#encoding:utf-8
#==============================================================================
# ■ Game_System
#------------------------------------------------------------------------------
# 　處理系統附屬數據的類。保存存檔和菜單的禁止狀態之類的數據。
#   本類的實例請參考 $game_system 。
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # ● 取得立繪控制物件
  #--------------------------------------------------------------------------
  def stand
    @stand ||= Lctseng::Game_StandController.new
  end
end


#encoding:utf-8
#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# 　顯示文字信息的窗口。
#==============================================================================

class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # ● 獲取窗口的高度
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(visible_line_number + 1)
  end
  #--------------------------------------------------------------------------
  # ● 換行文字的處理 【修改定義】
  #--------------------------------------------------------------------------
  def process_new_line(text, pos)
    @line_show_fast = false
    pos[:x] = pos[:new_x]
    pos[:y] += pos[:height]
    if !@first_line_process
      @first_line_process = true
      pos[:y] += 10
    end
    pos[:height] = calc_line_height(text)
    if need_new_page?(text, pos)
      input_pause
      new_page(text, pos)
    end
  end
end

#encoding:utf-8
#==============================================================================
# ■ Lctseng::Game_StandController
#------------------------------------------------------------------------------
# 　控制立繪物件
#==============================================================================

module Lctseng
class Game_StandController
  #--------------------------------------------------------------------------
  # ● 定義實例變數
  #--------------------------------------------------------------------------
  attr_reader :left
  attr_reader :right
  #--------------------------------------------------------------------------
  # ● 初始化對象
  #--------------------------------------------------------------------------
  def initialize
    @left = Game_LeftStand.new
    @right = Game_RightStand.new
  end
  #--------------------------------------------------------------------------
  # ● 當精靈組被釋放的時候的處理
  #--------------------------------------------------------------------------
  def on_terminate
    # 全部飛出
    left_slide_out
    right_slide_out
  end
  #--------------------------------------------------------------------------
  # ● 左圖片飛入
  #--------------------------------------------------------------------------
  def left_slide_in(filename)
    @left.change_filename(filename)
    @left.slide_in_req
  end
  #--------------------------------------------------------------------------
  # ● 左圖片飛出
  #--------------------------------------------------------------------------
  def left_slide_out
    @left.slide_out_req
  end
  #--------------------------------------------------------------------------
  # ● 左圖片最大透明限制
  #--------------------------------------------------------------------------
  def left_limit_opacity(value)
    @left.limit_opacity(value)
  end
  #--------------------------------------------------------------------------
  # ● 右圖片飛入
  #--------------------------------------------------------------------------
  def right_slide_in(filename)
    @right.change_filename(filename)
    @right.slide_in_req
  end
  #--------------------------------------------------------------------------
  # ● 右圖片飛出
  #--------------------------------------------------------------------------
  def right_slide_out
    @right.slide_out_req
  end
  #--------------------------------------------------------------------------
  # ● 右圖片最大透明限制
  #--------------------------------------------------------------------------
  def right_limit_opacity(value)
    @right.limit_opacity(value)
  end
  #--------------------------------------------------------------------------
  # ● 左圖片更換
  #--------------------------------------------------------------------------
  def left_change(filename,fast = false)
    @left.change(filename,fast)
  end
  #--------------------------------------------------------------------------
  # ● 右圖片更換
  #--------------------------------------------------------------------------
  def right_change(filename,fast = false)
    @right.change(filename,fast)
  end
end
end

#encoding:utf-8
#==============================================================================
# ■ Lctseng::Game_Stand
#------------------------------------------------------------------------------
# 　立繪物件
#==============================================================================

module Lctseng
class Game_Stand
  #--------------------------------------------------------------------------
  # ● 定義實例變數
  #--------------------------------------------------------------------------
  attr_reader :status
  attr_reader :filename
  attr_reader :new_filename
  attr_reader :old_filename
  attr_reader :change_fast
  attr_reader :opacity_limit
  attr_accessor :z
  #--------------------------------------------------------------------------
  # ● 初始化對象
  #--------------------------------------------------------------------------
  def initialize
    # 檔名
    @filename = ''
    # 狀態：
    # :none 無
    # :slide_in_req 要求飛入
    # :sliding_in   飛入中
    # slide_out_req  要求飛出 
    # :sliding_out  飛出中
    # :show 顯示中
    # :change_req 要求更換
    # :changing 更換中
    @status = :none
    # 更換時的新檔名【僅show中更換時生效】
    @new_filename = '' 
    # 更換時的舊檔名【僅show中更換時生效】
    @old_filename = ''
    # 更換時是否快速更換，代表立即顯示不淡入
    @change_fast = false
    #  Z 座標
    @z = 300
    # 透明度最大限制
    @opacity_limit = 255
  end

  #--------------------------------------------------------------------------
  # ● 回應飛入要求
  #--------------------------------------------------------------------------
  def response_slide_in
    @status = :sliding_in
  end
  #--------------------------------------------------------------------------
  # ● 回應飛入結束
  #--------------------------------------------------------------------------
  def response_slide_in_end
    @status = :show
  end
  #--------------------------------------------------------------------------
  # ● 回應飛出要求
  #--------------------------------------------------------------------------
  def response_slide_out
    @status = :sliding_out
  end
  #--------------------------------------------------------------------------
  # ● 回應飛出結束
  #--------------------------------------------------------------------------
  def response_slide_out_end
    @status = :none
  end
  #--------------------------------------------------------------------------
  # ● 回應更換要求
  #--------------------------------------------------------------------------
  def response_change_req
    @status = :changing
  end
  #--------------------------------------------------------------------------
  # ● 回應更換結束
  #--------------------------------------------------------------------------
  def response_change_end
    @status = :show
  end
  #--------------------------------------------------------------------------
  # ● 檔名更換
  #--------------------------------------------------------------------------
  def change_filename(new_name)
    @old_filename = @filename
    @new_filename = @filename = new_name
  end
  #--------------------------------------------------------------------------
  # ● 切換
  #--------------------------------------------------------------------------
  def change(new_name,fast)
    @change_fast = fast
    change_filename(new_name)
    @status = :change_req
  end
  #--------------------------------------------------------------------------
  # ● 要求飛入
  #--------------------------------------------------------------------------
  def slide_in_req
    @status = :slide_in_req 
  end
  #--------------------------------------------------------------------------
  # ● 要求飛出
  #--------------------------------------------------------------------------
  def slide_out_req
    @status = :slide_out_req if @status != :none
  end
  #--------------------------------------------------------------------------
  # ● 限制透明度
  #--------------------------------------------------------------------------
  def limit_opacity(value)
    @opacity_limit = value
  end
  
end
end

#encoding:utf-8
#==============================================================================
# ■ Lctseng::Game_LeftStand
#------------------------------------------------------------------------------
# 　左方立繪物件
#==============================================================================

module Lctseng
class Game_LeftStand < Game_Stand
  #--------------------------------------------------------------------------
  # ● 初始化對象
  #--------------------------------------------------------------------------
  def initialize
    super
  end


end
end

#encoding:utf-8
#==============================================================================
# ■ Lctseng::Game_RightStand
#------------------------------------------------------------------------------
# 　右方立繪物件
#==============================================================================

module Lctseng
class Game_RightStand < Game_Stand
  #--------------------------------------------------------------------------
  # ● 初始化對象
  #--------------------------------------------------------------------------
  def initialize
    super
  end


end
end

#encoding:utf-8
#==============================================================================
# ■ Lctseng::Spriteset_Stand
#------------------------------------------------------------------------------
#     處理立繪的精靈組
#     監視Game_StandController進行立繪處理
#==============================================================================
module Lctseng
class Spriteset_Stand
  #--------------------------------------------------------------------------
  # ● 加入設定模組
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # ● 初始化對象
  #--------------------------------------------------------------------------
  def initialize(viewport)
    @viewport = viewport
    @terminating_count = 0
    create_sprites
  end
  #--------------------------------------------------------------------------
  # ● 取得控制器
  #--------------------------------------------------------------------------
  def control
    $game_system.stand
  end
  #--------------------------------------------------------------------------
  # ● 產生精靈
  #--------------------------------------------------------------------------
  def create_sprites
    @left = Lctseng::Sprite_LeftStand.new(@viewport)
    @right = Lctseng::Sprite_RightStand.new(@viewport)
  end
  #--------------------------------------------------------------------------
  # ● 釋放
  #--------------------------------------------------------------------------
  def dispose
    dispose_sprites
  end
  #--------------------------------------------------------------------------
  # ● 釋放精靈
  #--------------------------------------------------------------------------
  def dispose_sprites
    @left.dispose
    @right.dispose
  end
  #--------------------------------------------------------------------------
  # ● 釋放
  #--------------------------------------------------------------------------
  def any_sprite_show?
    return true if @left&&@left.control.status != :none
    return true if @right&&@right.control.status != :none
    return false
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    update_sprites
  end
  #--------------------------------------------------------------------------
  # ● 更新精靈
  #--------------------------------------------------------------------------
  def update_sprites
    @left.update
    @right.update
  end
  #--------------------------------------------------------------------------
  # ● 結束計數
  #--------------------------------------------------------------------------
  def terminate_countdown
    @terminating_count -= 1
  end

  #--------------------------------------------------------------------------
  # ● 結束中？
  #--------------------------------------------------------------------------
  def terminating?
    @terminating_count > 0
  end
  #--------------------------------------------------------------------------
  # ● 終止
  #--------------------------------------------------------------------------
  def terminate
    puts "終止處理"
    control.on_terminate
    if any_sprite_show?
      puts "要求終止前顯示"
      @terminating_count  = 35
    end
  end

end
end

#encoding:utf-8
#==============================================================================
# ■ Lctseng::Sprite_Stand
#------------------------------------------------------------------------------
#     立繪精靈
#==============================================================================
module Lctseng
class Sprite_Stand < Sprite_Base
  #--------------------------------------------------------------------------
  # ● 加入淡入淡出與移動模組
  #--------------------------------------------------------------------------
  include SpriteFader
  include SpriteSlider
  #--------------------------------------------------------------------------
  # ● 初始化對象
  #--------------------------------------------------------------------------
  def initialize(viewport)
    @opacity_limit = 255
    @origin_opacity = 255
    super(viewport)
    @origin_opacity = self.opacity
    @filename = ''
    check_opacity
    fader_init
    slider_init
    @shadow = Sprite_StandShadow.new(self,viewport)
  end
  #--------------------------------------------------------------------------
  # ● 取得控制物件
  #--------------------------------------------------------------------------
  def control
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    super
    check_opacity
    check_action
    fader_update
    slider_update
    self.z = control.z
    @shadow.update
  end
  #--------------------------------------------------------------------------
  # ● 設定透明度
  #--------------------------------------------------------------------------
  alias :set_opacity :opacity=
  #--------------------------------------------------------------------------
  def opacity=(val)
    @origin_opacity = val
    adj = [@origin_opacity,@opacity_limit].min
    set_opacity(adj)
  end
  #--------------------------------------------------------------------------
  # ● 檢查透明度
  #--------------------------------------------------------------------------
  def check_opacity
    if  @opacity_limit != control.opacity_limit
      @opacity_limit = control.opacity_limit
      self.opacity = @origin_opacity
    end
  end
  #--------------------------------------------------------------------------
  # ● 檢查動作
  #--------------------------------------------------------------------------
  def check_action
    #puts "狀態：#{control.status}"
    case control.status
    when :none
      hide
    when :slide_in_req
      check_filename
      reset_position
      slide_in
      control.response_slide_in
    when :sliding_in
      if !slider_sliding?
        control.response_slide_in_end
      end
    when :slide_out_req
      slide_out
      control.response_slide_out
    when :sliding_out
      if !slider_sliding?
        control.response_slide_out_end
      end
    when :change_req
      if control.change_fast
        change_immediately
        control.response_change_end
      else
        setup_shadow
        control.response_change_req
      end
    when :changing
      if !fader_fading? && !@shadow.fader_fading?
        control.response_change_end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 隱藏
  #--------------------------------------------------------------------------
  def hide
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● 檢查檔名
  #--------------------------------------------------------------------------
  def check_filename
    # 若檔案更換，則重新建立位圖
    if @filename != control.filename
      change_immediately
    end
  end
  #--------------------------------------------------------------------------
  # ● 重置位置
  #--------------------------------------------------------------------------
  def reset_position
    return unless self.bitmap
    set_pos(slided_out_pos)
  end
  #--------------------------------------------------------------------------
  # ● 取得已飛入的位置
  #--------------------------------------------------------------------------
  def slided_in_pos
    [0,Graphics.height - self.height]
  end
  #--------------------------------------------------------------------------
  # ● 取得已飛出的位置
  #--------------------------------------------------------------------------
  def slided_out_pos
    [-0.5 * self.width,Graphics.height - self.height]
  end
  #--------------------------------------------------------------------------
  # ● 釋放
  #--------------------------------------------------------------------------
  def dispose
    super
    @shadow.dispose
  end
  #--------------------------------------------------------------------------
  # ● 飛入顯示
  #--------------------------------------------------------------------------
  def slide_in
    fader_set_fade(255,30)
    slider_set_move(current_pos,slided_in_pos,30)
  end
  #--------------------------------------------------------------------------
  # ● 飛出隱藏
  #--------------------------------------------------------------------------
  def slide_out
    fader_set_fade(0,30)
    slider_set_move(current_pos,slided_out_pos,30)
  end
  #--------------------------------------------------------------------------
  # ● 立即更換
  #--------------------------------------------------------------------------
  def change_immediately
    @filename = control.filename
    self.bitmap = Cache.picture(@filename)
    # 重新對齊座標
    set_pos(slide_in_pos_adjust(slided_in_pos))
    # 設定透明度
    self.opacity = 255
  end
  #--------------------------------------------------------------------------
  # ● 設置陰影
  # 將舊圖片作為殘影，主精靈使用新圖片淡入
  #--------------------------------------------------------------------------
  def setup_shadow
    @shadow.setup
    change_immediately
    self.opacity = 0
    fader_set_fade(255,30)
  end
  #--------------------------------------------------------------------------
  # ● 已飛入位置調整
  #--------------------------------------------------------------------------
  def slide_in_pos_adjust(pos)
    pos
  end
end
end

#encoding:utf-8
#==============================================================================
# ■ Lctseng::Sprite_StandShadow
#------------------------------------------------------------------------------
#     立繪陰影精靈，主精靈更換圖片時，用來淡出舊圖片
#==============================================================================
module Lctseng
class Sprite_StandShadow < Sprite_Base
  #--------------------------------------------------------------------------
  # ● 加入淡入淡出與移動模組
  #--------------------------------------------------------------------------
  include SpriteFader
  #--------------------------------------------------------------------------
  # ● 初始化對象
  #--------------------------------------------------------------------------
  def initialize(main,viewport)
    super(viewport)
    @main = main
    fader_init
  end

  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    super
    fader_update
  end
  #--------------------------------------------------------------------------
  # ● 設置
  #--------------------------------------------------------------------------
  def setup
    self.bitmap = Cache.picture(@main.control.old_filename)
    self.opacity = @main.opacity
    self.x = @main.x
    self.y = @main.y
    fader_set_fade(0,30)
  end
end
end


#encoding:utf-8
#==============================================================================
# ■ Lctseng::Sprite_LeftStand
#------------------------------------------------------------------------------
#     左方立繪精靈
#==============================================================================
module Lctseng
class Sprite_LeftStand < Sprite_Stand
  #--------------------------------------------------------------------------
  # ● 取得控制物件
  #--------------------------------------------------------------------------
  def control
    $game_system.stand.left
  end
  #--------------------------------------------------------------------------
  # ● 重置位置
  #--------------------------------------------------------------------------
  def reset_position
    return unless self.bitmap
    super
    self.x = self.width * -0.5
  end
  #--------------------------------------------------------------------------
  # ● 取得已飛入的位置
  #--------------------------------------------------------------------------
  def slided_in_pos
    pos = super
    pos[0] = 0 # x座標為0
    slide_in_pos_adjust(pos)
  end
  #--------------------------------------------------------------------------
  # ● 已飛入位置調整
  #--------------------------------------------------------------------------
  def slide_in_pos_adjust(pos)
    # 限制不過半
    if pos[0] + self.width > 320
      pos[0] = 320 - self.width
    end
    pos
  end
  #--------------------------------------------------------------------------
  # ● 取得已飛出的位置
  #--------------------------------------------------------------------------
  def slided_out_pos
    pos = super
    pos[0] = -0.5 * self.width # x座標為負的一半寬度
    pos
  end
  
end
end


#encoding:utf-8
#==============================================================================
# ■ Lctseng::Sprite_RightStand
#------------------------------------------------------------------------------
#     右方立繪精靈
#==============================================================================
module Lctseng
class Sprite_RightStand < Sprite_Stand
  #--------------------------------------------------------------------------
  # ● 取得控制物件
  #--------------------------------------------------------------------------
  def control
    $game_system.stand.right
  end
  #--------------------------------------------------------------------------
  # ● 重置位置
  #--------------------------------------------------------------------------
  def reset_position
    return unless self.bitmap
    super
    self.x = Graphics.width - self.width * 0.5
  end
  #--------------------------------------------------------------------------
  # ● 取得已飛入的位置
  #--------------------------------------------------------------------------
  def slided_in_pos
    pos = super
    pos[0] = Graphics.width - self.width 
    slide_in_pos_adjust(pos)
  end
  #--------------------------------------------------------------------------
  # ● 已飛入位置調整
  #--------------------------------------------------------------------------
  def slide_in_pos_adjust(pos)
    # 限制不過半
    if pos[0] < 320
      pos[0] = 320
    end
    pos
  end
  #--------------------------------------------------------------------------
  # ● 取得已飛出的位置
  #--------------------------------------------------------------------------
  def slided_out_pos
    pos = super
    pos[0] = Graphics.width - self.width * 0.5
    pos
  end
end
end

#encoding:utf-8
#==============================================================================
# ■ Scene_Base
#------------------------------------------------------------------------------
# 　游戲中所有 Scene 類（場景類）的父類
#==============================================================================

class Scene_Base
  #--------------------------------------------------------------------------
  # ● 重新定義
  #--------------------------------------------------------------------------
  unless $@
    alias lctseng_stand_start start
    alias lctseng_stand_update_basic update_basic
    alias lctseng_stand_terminate terminate
  end
  #--------------------------------------------------------------------------
  # ● 開始處理 【重新定義】
  #--------------------------------------------------------------------------
  def start
    lctseng_stand_start
    #create_stand_viewport
    create_stand_spriteset
  end
  #--------------------------------------------------------------------------
  # ● 產生立繪顯示端口
  #--------------------------------------------------------------------------
  def create_stand_viewport
    @viewport_stand = Viewport.new
    @viewport_stand.z = 100
  end
  #--------------------------------------------------------------------------
  # ● 產生立繪精靈
  #--------------------------------------------------------------------------
  def create_stand_spriteset
    # 修改不使用顯示端口，以便控制Z座標
    @stand_spriteset = Lctseng::Spriteset_Stand.new(nil)
  end
  #--------------------------------------------------------------------------
  # ● 更新畫面（基礎）【重新定義】
  #--------------------------------------------------------------------------
  def update_basic
    lctseng_stand_update_basic
    update_stand_spriteset
  end
  #--------------------------------------------------------------------------
  # ● 更新立繪精靈
  #--------------------------------------------------------------------------
  def update_stand_spriteset
    @stand_spriteset.update
  end
  #--------------------------------------------------------------------------
  # ● 結束處理【重新定義】
  #--------------------------------------------------------------------------
  def terminate
    stand_terminate
    lctseng_stand_terminate
    dispose_stand_spriteset
    #dispose_stand_viewport
  end
  #--------------------------------------------------------------------------
  # ● 釋放立繪精靈
  #--------------------------------------------------------------------------
  def dispose_stand_spriteset
    @stand_spriteset.dispose
  end
  #--------------------------------------------------------------------------
  # ● 釋放立繪顯示端口
  #--------------------------------------------------------------------------
  def dispose_stand_viewport
    @viewport_stand.dispose
  end
  #--------------------------------------------------------------------------
  # ● 立繪結束處理
  #--------------------------------------------------------------------------
  def stand_terminate
    @stand_spriteset.terminate
    while @stand_spriteset.terminating?
      @stand_spriteset.terminate_countdown
      puts "結束前處理"
      @stand_spriteset.update
      Graphics.update
    end
  end

end

#encoding:utf-8
#==============================================================================
# ■ Scene_Map
#------------------------------------------------------------------------------
# 　地圖畫面
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● 重新定義
  #--------------------------------------------------------------------------
  unless $@
    alias lctseng_stand_pre_transfer pre_transfer
  end

  #--------------------------------------------------------------------------
  # ● 場所移動前的處理【重新定義】
  #--------------------------------------------------------------------------
  def pre_transfer
    puts "場所移動處理"
    stand_terminate
    lctseng_stand_pre_transfer
  end
end





  
