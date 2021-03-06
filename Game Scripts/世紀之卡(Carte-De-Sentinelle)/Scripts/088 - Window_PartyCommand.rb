#encoding:utf-8
#==============================================================================
# ■ Window_PartyCommand
#------------------------------------------------------------------------------
# 　戰斗畫面中，選擇“戰斗／撤退”的窗口。
#==============================================================================

class Window_PartyCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● 初始化對象
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    self.openness = 0
    deactivate
  end
  #--------------------------------------------------------------------------
  # ● 獲取窗口的寬度
  #--------------------------------------------------------------------------
  def window_width
    return 128
  end
  #--------------------------------------------------------------------------
  # ● 獲取顯示行數
  #--------------------------------------------------------------------------
  def visible_line_number
    return 4
  end
  #--------------------------------------------------------------------------
  # ● 生成指令列表
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::fight,  :fight)
    add_command(Vocab::escape, :escape, BattleManager.can_escape?)
  end
  #--------------------------------------------------------------------------
  # ● 設置
  #--------------------------------------------------------------------------
  def setup
    clear_command_list
    make_command_list
    refresh
    select(0)
    activate
    open
  end
end
